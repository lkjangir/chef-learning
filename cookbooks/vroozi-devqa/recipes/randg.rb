  #install randg 


%w{gcc-c++ patch readline readline-devel zlib zlib-devel libyaml-devel libffi-devel openssl-devel make bzip2 autoconf automake libtool bison glibc}.each do |pkg|
	package pkg do
	end
end

bash 'install-ruby-dependencies' do
  user 'root'
  cwd '/root'
  code <<-EOH
    set -x
    curl -sSL https://rvm.io/mpapis.asc | sudo gpg2 --import -
    curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
    curl -sSL https://get.rvm.io | sudo bash -s stable
    source /etc/profile.d/rvm.sh
    rvm install 2.1.2
    rvm use 2.1.2 --default
  EOH
  not_if 'ruby --version | grep 2.1.2'
end


package 'rubygems' do
  action :install
end

execute 'gem-update' do
  command 'gem update --system'
  action :run
end

execute 'install_compass' do
  command '/usr/local/rvm/rubies/ruby-2.1.2/bin/gem install compass'
  action :run
end

execute 'install_gulp' do
  command 'source /root/.nvm/nvm.sh && npm install -g gulp'
  action :run
  user 'root'
end






