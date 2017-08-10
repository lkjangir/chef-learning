#solr installation 


execute 'download_solr' do
  command "wget http://archive.apache.org/dist/lucene/solr/#{node['solr']['version']}/solr-#{node['solr']['version']}.tgz"
  creates "/tmp/solr-#{node['solr']['version']}.tgz"
  cwd '/tmp'
  action :run
end

execute 'extract_solr' do
  command "tar -zxvf /tmp/solr-#{node['solr']['version']}.tgz -C /tmp/"
  creates "/tmp/solr-#{node['solr']['version']}"
  action :run
end

execute 'install-solr' do
  command "/tmp/solr-#{node['solr']['version']}/bin/install_solr_service.sh /tmp/solr-#{node['solr']['version']}.tgz -f"
  action :run
end

execute 'uddate-solr-heap-to-4096' do
  command "sed -i 's/^SOLR_HEAP.*$/SOLR_HEAP=\"4096m\"/g' /etc/default/solr.in.sh"
  creates '/tmp/something'
  action :run
end

cookbook_file '/var/solr/data/solr.xml' do
  source 'solr.xml'
  owner 'solr'
  group 'solr'
  mode '0640'
end

execute 'download_solr_data' do
  command "aws s3 cp s3://#{node['vroozi_packages']['s3_bucket']}/solr-master-data.tar.gz /tmp/solr-master-data.tar.gz"
  creates "/tmp/solr-master-data.tar.gz"
  cwd '/tmp'
  action :run
end

execute 'restore_solr_data' do
  command 'tar -zxvf /tmp/solr-master-data.tar.gz -C /var/ --overwrite'
  action :run
  user 'root'
end

execute 'import-configuration-solr' do
  command '/opt/zookeeper/bin/zkCli.sh cmd upconfig -zkhost 127.0.0.1:2181 -confdir /var/solr/data/ -confname common'
  action :run
  user 'root'
end

execute 'change-solr-permissions' do
  command 'chown -R solr:solr /opt/solr* /var/solr'
  action :run
end

service 'solr' do
  action [:restart, :enable]
end



