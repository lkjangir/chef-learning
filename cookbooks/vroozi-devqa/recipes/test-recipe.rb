

file '/usr/share/nginx/html/hello.txt' do
  action :create
  owner 'root'
  group 'root'
  mode '0777'
  content "#{node['vroozi']['name']}"
end
