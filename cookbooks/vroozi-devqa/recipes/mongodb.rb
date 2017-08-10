#variables - 
mongo_dump = node['mongodb']['backup_file']
mongo_tmp_dumpdir = ::File.join('/tmp/', (mongo_dump.gsub ".zip", ""))

#install mongodb 
file '/etc/yum.repos.d/01mongodb.repo' do
  action :create
  owner 'root'
  group 'root'
  mode '0644'
  content <<-EOH
[mongodb-org-3.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/amazon/2013.03/mongodb-org/3.2/x86_64/
gpgcheck=0
enabled=1
EOH
end

execute 'install_mongodb' do
  command 'yum install --enablerepo=mongodb-org-3.2 mongodb-org-3.2.9-1.amzn1.x86_64 -y'
  action :run
end

#copy mongod.conf file - 
cookbook_file '/tmp/mongod-tmp.conf' do
  source 'mongod-tmp.conf'
  owner 'mongod'
  group 'mongod'
  mode '0755'
  action :create
end

execute 'kill-mongodb-process' do
  command 'kill -9 $(pidof mongod)'
  action :run
  only_if 'pidof mongod'
end

execute 'start-mongod-tempconf' do
  command 'mongod --config /tmp/mongod-tmp.conf'
  action :run
end

#remove dump directory 
#directory '/tmp/vroozi_mongo_dumps' do
directory mongo_tmp_dumpdir do
  action :delete
  recursive true
  user 'root'
end

#fetch backup 
execute 'download_mongo_backup' do
  command "aws s3 cp s3://#{node['mongodb']['backup_s3_bucket']}/#{node['mongodb']['backup_file']} /tmp/#{node['mongodb']['backup_file']}"
  action :run
end

#unzip backup file 
execute 'unzip_mongodb_dumpfile' do
  command "unzip -o /tmp/#{node['mongodb']['backup_file']}"
  action :run
  cwd '/tmp'
  user 'root'
end

#restore DB
#ruby_block 'restore_mongo_db' do
#  block do
#    Dirs = Dir.entries(mongo_tmp_dumpdir)
#    Dirs.sort.each do |d|
#      next if d.to_s == '.' or d.to_s == '..'
#      %x[mongorestore --db #{d} --drop #{File.join(mongo_tmp_dumpdir, d)}]
#    end
#  end
#end

execute 'restore_mongo_db' do
  command "mongorestore /tmp/dump/ --drop --noIndexRestore"
  action :run
end

execute 'chown-mongdb-dir' do
  command 'chown -R mongod:mongod /var/lib/mongo'
  action :run
end

service 'mongod' do
  action [:nothing, :enable]
end

#copy mongod.conf file - 
cookbook_file '/etc/mongod.conf' do
  source 'mongod.conf'
  owner 'mongod'
  group 'mongod'
  mode '0755'
  action :create
end

cookbook_file '/etc/init.d/mongod' do
  source 'mongod-initd'
  owner 'mongod'
  group 'mongod'
  mode '0755'
  action :create
  #notifies :restart, 'service[mongod]', :immediately
end

#for final restart. 
service 'mongod' do
  action [:restart, :enable]
end

  

