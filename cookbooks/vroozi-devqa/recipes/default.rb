#
# Cookbook Name:: vroozi-devqa
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
#include_recipe 'aws'


#tomcat_install 'tomcat' do
#  tarball_uri 'https://s3.amazonaws.com/vroozi-req-software/apache-tomcat-7.0.62.tar.gz'
#  tomcat_user 'tomcat'
#  tomcat_group 'tomcat'
#end


#Fetching Tomcat file from S3
#file '/home/index.php' do
#  content '<html>This is a placeholder for the home page.</html>'
#end
include_recipe 'vroozi-devqa::common' if node['vroozi_packages']['install_common']

include_recipe 'vroozi-devqa::mongodb' if node['vroozi_packages']['install_mongodb']
include_recipe 'vroozi-devqa::nodejs' if node['vroozi_packages']['install_nodejs']
include_recipe 'vroozi-devqa::tomcat' if node['vroozi_packages']['install_tomcat']
include_recipe 'vroozi-devqa::java' if node['vroozi_packages']['install_java']

include_recipe 'vroozi-devqa::zookeeper' if node['vroozi_packages']['install_zookeeper']
include_recipe 'vroozi-devqa::w_nginx' if node['vroozi_packages']['install_nginx']
include_recipe 'vroozi-devqa::elasticsearch' if node['vroozi_packages']['install_elasticsearch']
include_recipe 'vroozi-devqa::maven' if node['vroozi_packages']['install_maven']
include_recipe 'vroozi-devqa::randg' if node['vroozi_packages']['install_randg']
include_recipe 'vroozi-devqa::solr' if node['vroozi_packages']['install_solr']
include_recipe 'vroozi-devqa::tokumx' if node['vroozi_packages']['install_tokumx']




include_recipe 'vroozi-devqa::start_services'
