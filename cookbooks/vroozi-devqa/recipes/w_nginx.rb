
#include_recipe 'chef_nginx::default'


package 'nginx' do
  action :install
end

template '/etc/nginx/nginx.conf' do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/nginx/conf.d/sso.conf' do
  source 'sso.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/nginx/conf.d/adminui.conf' do
  source 'adminui.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/nginx/conf.d/event-service.conf' do
  source 'event-service.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/nginx/conf.d/file-storage-service.conf' do
  source 'file-storage-service.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/nginx/conf.d/login.conf' do
  source 'login.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/nginx/conf.d/message_center.conf' do
  source 'message_center.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/nginx/conf.d/purchase_manager.conf' do
  source 'purchase_manager.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/nginx/conf.d/registration.conf' do
  source 'registration.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

template '/etc/nginx/conf.d/shopper.conf' do
  source 'shopper.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
end

execute 'install_nginx_cert' do
  command "aws s3 cp s3://#{node['v2-admin-ui']['s3_bucket']}/cert/#{node['nginx']['ssl_certificate_name']} #{node['nginx']['ssl_certificate_filepath']}"
  action :run
end

execute 'install_nginx_certkey' do
  command "aws s3 cp s3://#{node['v2-admin-ui']['s3_bucket']}/cert/#{node['nginx']['ssl_certificatekey_name']} #{node['nginx']['ssl_certificatekey_filepath']}"
  action :run
end







