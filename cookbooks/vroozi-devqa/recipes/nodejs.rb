

#bash 'intall_nodejs' do
#  user 'root'
#  cwd '/root'
#  code <<-EOH
#  	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.32.0/install.sh | bash
#  	source ~/.nvm/nvm.sh
#  	nvm install 5.11.0
#  	cd /usr/local/lib/ && npm install forever
#  	ln -s /usr/local/lib/node_modules/forever/bin/forever /usr/bin/forever
#  EOH
#  not_if { ::File::exist?('/root/.nvm/nvm.sh')}
#end

git '/root/.nvm' do
  provider Chef::Provider::Git
  repository 'git://github.com/creationix/nvm.git'
  revision 'master'
  action :sync
  user 'root'
end

bash 'intall_forever' do
  user 'root'
  cwd '/root'
  code <<-EOH
    source /root/.nvm/nvm.sh
    nvm install 5.11.0
    cd /usr/local/lib/ && npm install forever
    ln -s /usr/local/lib/node_modules/forever/bin/forever /usr/bin/forever
  EOH
  creates '/usr/bin/forever'
end

template '/etc/init.d/forever' do
  source 'forever.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

