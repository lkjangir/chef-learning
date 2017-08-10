

execute 'download_tokumx_common' do
  command "aws s3 cp s3://#{node['vroozi_packages']['s3_bucket']}/#{node['vroozi_packages']['tokumx_common']} /tmp/#{node['vroozi_packages']['tokumx_common']}"
  action :run
end

execute 'install_tokumx_common' do
  command "yum install /tmp/#{node['vroozi_packages']['tokumx_common']} -y"
  action :run
  nof_if "rpm -q #{node['vroozi_packages']['tokumx_common']}"
end

execute 'download_tokumx_server' do
  command "aws s3 cp s3://#{node['vroozi_packages']['s3_bucket']}/#{node['vroozi_packages']['tokumx_server']} /tmp/#{node['vroozi_packages']['tokumx_server']}"
  action :run
end

execute 'install_tokumx_server' do
  command "yum install /tmp/#{node['vroozi_packages']['tokumx_server']} -y"
  action :run
end

execute 'download_tokumx' do
  command "aws s3 cp s3://#{node['vroozi_packages']['s3_bucket']}/#{node['vroozi_packages']['tokumx']} /tmp/#{node['vroozi_packages']['tokumx']}"
  action :run
end

execute 'install_tokumx' do
  command "yum install /tmp/#{node['vroozi_packages']['tokumx']} -y"
  action :run
end