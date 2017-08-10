#install zookeeper 


#download tar file - 
execute 'download_zookeeper_tar' do
  command "wget http://www-us.apache.org/dist/zookeeper/zookeeper-#{node['zookeeper']['version']}/zookeeper-#{node['zookeeper']['version']}.tar.gz"
  cwd '/tmp/'
  creates "/tmp/zookeeper-#{node['zookeeper']['version']}.tar.gz"
  action :run
end

execute 'extract_zookeeper_tar' do
  command "tar -zxvf /tmp/zookeeper-#{node['zookeeper']['version']}.tar.gz -C /opt/"
  creates "/opt/zookeeper-#{node['zookeeper']['version']}"
  action :run
end

execute 'create-symlink' do
  command "ln -s /opt/zookeeper-#{node['zookeeper']['version']}/ /opt/zookeeper"
  action :run
  not_if '[ -L /opt/zookeeper ]'
end

directory node['zookeeper']['data_dir']	do
  owner 'ec2-user'
  group 'ec2-user'
  mode '0775'
  recursive true
  action :create
end

template '/opt/zookeeper/conf/zoo.cfg' do
  source 'zookeeper.conf.erb'
  owner 'ec2-user'
  group 'ec2-user'
  mode '0755'
end

template '/etc/init.d/zookeeper' do
  source 'zkServer-initd.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

execute 'download-zookeeper-data' do
  command "aws s3 cp s3://#{node['vroozi_packages']['s3_bucket']}/#{node['zookeeper']['data_file']} /tmp/#{node['zookeeper']['data_file']}"
  action :run
end

execute 'extract-zookeeper-data' do
  command "tar -zxvf /tmp/#{node['zookeeper']['data_file']} -C /var/ --overwrite"
  action :run
end

service 'zookeeper' do
  action [:start, :enable]
end
