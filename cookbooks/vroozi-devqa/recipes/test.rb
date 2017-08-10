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

execute 'start_mongodb' do
  command '/etc/init.d/mongod restart'
  action :run
end





#remove directory 
directory '/tmp/vroozi_mongo_dumps' do
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
log 'getting absolute path of zip'
f1 = node['mongodb']['backup_file']
f = ::File.join('/tmp/', (f1.gsub ".zip", ""))
log "got path #{f}"


ruby_block 'restore_mongo_db' do
	block do
		h = Dir.entries(f)
		h.sort.each do |d|
  		next if d.to_s == '.' or d.to_s == '..'
  		%x[mongorestore --db #{d} --drop #{File.join(f, d)}]
		end
	end
end

#h = Dir.entries(f)
#h.sort.each do |d|
#	next if d.to_s == '.' or d.to_s == '..'
#	log "restoring backup:------- #{d}"
#  execute "restore-db-#{d}" do
#  	command "mongorestore --db #{d} --drop #{File.join(f, d)}"
#  	action :run
#  	user 'root'
#  end
#end




#	log "backup restoration done:------- #{m}"
#end

	