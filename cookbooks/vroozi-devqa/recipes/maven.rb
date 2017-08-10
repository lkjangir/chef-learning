# Maven installation 

execute 'download_maven' do
  command "aws s3 cp s3://#{node['vroozi_packages']['s3_bucket']}/#{node['vroozi_packages']['maven_pkg_name']} /tmp/#{node['vroozi_packages']['maven_pkg_name']}"
  action :run
end

execute 'extract_maven' do
  command "tar -zxvf /tmp/#{node['vroozi_packages']['maven_pkg_name']} -C /usr/local/src/"
  creates "/usr/local/src/maven/"
  action :run
end

bash 'create_symlink' do
  user 'root'
  code <<-EOH
  	maven_pkg="#{node['vroozi_packages']['maven_pkg_name']}"
  	maven_dir=${maven_pkg/%-bin.tar.gz/}
  	echo $maven_dir > /home/file
  	ln -s /usr/local/src/${maven_dir}/ /usr/local/src/maven
  EOH
  not_if {::File.exist?('/usr/local/src/maven')}
end


