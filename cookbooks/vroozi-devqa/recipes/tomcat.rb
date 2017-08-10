
#

execute 'fetch_tomcat' do
  command 'aws s3 cp s3://vroozi-req-software/apache-tomcat-7.0.62.tar.gz /tmp/apache-tomcat-7.0.62.tar.gz'
  not_if { ::Dir.exist?("/usr/share/tomcat7") }	
end

execute 'extract_tomcat' do
  command 'tar -zxvf /tmp/apache-tomcat-7.0.62.tar.gz -C /tmp/'
  not_if { ::Dir.exist?("/usr/share/tomcat7") }
end

execute 'rename_tomcat' do
  command 'mv $(find /tmp/ -type d -name "apache-tomcat*") /usr/share/tomcat7'
  not_if { ::Dir.exist?("/usr/share/tomcat7") }
end

execute 'cataline_home' do
  command 'echo CATALINA_HOME=/usr/share/tomcat7 >> /etc/environment'
  not_if 'grep CATALINA_HOME /etc/environment'
end

group 'tomcat' do
  action :create
end

user 'tomcat' do
  action :create
  comment 'tomcat user for Tomcat application'
  group 'tomcat'
  shell '/sbin/nologin'
end

execute 'change-tomcat-permission' do
  command "chown -R tomcat:tomcat #{node['tomcat']['install_dir']}"
  action :run
end

cookbook_file '/etc/init.d/tomcat7' do
  source 'tomcat7-initd-script'
  owner 'root'
  group 'root'
  mode '0755'
end

file '/etc/logrotate.d/tomcat' do
  action :create
  owner 'root'
  group 'root'
  mode '0644'
  content '/usr/share/tomcat7/logs/catalina.out {   copytruncate   daily   rotate 3   compress   missingok   size 50M  }'
end

service 'tomcat7' do
  action [:start, :enable]
end


