

default['vroozi_packages']['install_common'] = true
default['tomcat']['install_dir'] = '/usr/share/tomcat7'
default['nodejs']['deploy_directory'] = '/var/nodejs'

default['vroozi_packages']['install_nginx']  = true
default['vroozi_packages']['install_mongodb'] = true
default['vroozi_packages']['install_tomcat'] = true
default['vroozi_packages']['install_nodejs'] = true
default['vroozi_packages']['install_java'] = true
default['vroozi_packages']['install_zookeeper'] = true

default['nginx']['dir']	= '/etc/nginx'
default['nginx']['upstream_ip']					= '127.0.0.1'
default['nginx']['upstream_port_adminui']		= '8080'

default['nginx']['upstream_port_sso']			= '8080'

default['nginx']['upstream_port_eventsrv']		= '8882'

default['nginx']['upstream_port_storagenode'] = '8880'

default['nginx']['upstream_port_loginnodes1'] = '6001'
default['nginx']['upstream_port_loginnodes2'] = '6002'
default['nginx']['upstream_port_loginnodes3'] = '6003'
default['nginx']['upstream_port_loginnodes4'] = '6004'

default['nginx']['upstream_port_msgnodes1'] 	= '7001'
default['nginx']['upstream_port_msgnodes2'] 	= '7002'
default['nginx']['upstream_port_msgnodes3'] 	= '7003'
default['nginx']['upstream_port_msgnodes4'] 	= '7004'

default['nginx']['upstream_port_purchasenode1'] = '5001'
default['nginx']['upstream_port_purchasenode2'] = '5002'
default['nginx']['upstream_port_purchasenode3'] = '5003'
default['nginx']['upstream_port_purchasenode4'] = '5004'

default['nginx']['upstream_port_registration1'] = '8001'
default['nginx']['upstream_port_registration2'] = '8002'
default['nginx']['upstream_port_registration3'] = '8003'
default['nginx']['upstream_port_registration4'] = '8004'

default['nginx']['upstream_port_shopper1'] 		= '4001'
default['nginx']['upstream_port_shopper2'] 		= '4002'
default['nginx']['upstream_port_shopper3'] 		= '4003'
default['nginx']['upstream_port_shopper4'] 		= '4004'


default['nginx']['http_port']	= '80'
default['nginx']['https_port']	= '443'

default['nginx']['user']	= 'nginx'
default['nginx']['worker_processes'] = '1'
				
default['nginx']['error_log_path']	= '/var/log/nginx/error.log'
default['nginx']['log_level']	= 'warn'
default['nginx']['access_log_path']	= '/var/log/nginx/access.log'

default['nginx']['log_format']	= 'logstash'	# choose one from main or logstash

default['vroozi']['domain_name']	= 'devqa17'

default['nginx']['ssl_certificate_name'] 	= 'vroozi.com.crt'
default['nginx']['ssl_certificatekey_name'] 	= 'nopassvroozicom.key'

default['nginx']['ssl_certificate_filepath'] 	= '/etc/nginx/cert/vroozi.com.crt'
default['nginx']['ssl_certificatekey_filepath'] 	= '/etc/nginx/cert/nopassvroozicom.key'
default['nginx']['setup_htpasswd']			 			= false
default['nginx']['htpasswd_filepath']        	= '/etc/nginx/.htpasswd'

default['vroozi_packages']['s3_bucket'] 		= 'vroozi-req-software'

# => elasticsearch 
default['vroozi_packages']['install_elasticsearch'] = true
default['vroozi_packages']['es_pkg_name'] 		= 'elasticsearch-0.90.13.noarch.rpm'

# => maven
default['vroozi_packages']['install_maven'] 	= true
default['vroozi_packages']['maven_pkg_name'] 	= 'apache-maven-3.2.5-bin.tar.gz'


#solr
default['vroozi_packages']['install_solr'] 		= true
default['solr']['version'] = '6.1.0'

#randg
default['vroozi_packages']['install_randg'] 	= true

#Tokumx
default['vroozi_packages']['install_tokumx'] 	= false
default['vroozi_packages']['tokumx_common'] 	= 'tokumx-common-2.0.1-1.el6.x86_64.rpm'
default['vroozi_packages']['tokumx_server'] 	= 'tokumx-server-2.0.1-1.el6.x86_64.rpm'
default['vroozi_packages']['tokumx']			= 'tokumx-2.0.1-1.el6.x86_64.rpm'

## Mongo DB
default['mongodb']['restore_backup'] = true
default['mongodb']['backup_s3_bucket']	=	'vroozi-req-software'
default['mongodb']['backup_file'] = 'vroozi_mongo_dumps_devqa11.zip'

default['mongodb']['username'] = 'vrooziadmin'
default['mongodb']['password'] = '0vr00zi009'

#Zookeeper - 
default['zookeeper']['install'] = true
default['zookeeper']['version'] = '3.4.6'
default['zookeeper']['data_dir'] = '/var/zookeeper/data'
default['zookeeper']['install_location'] = '/opt'
default['zookeeper']['data_file'] = 'zookeeper_data.tar.gz'

#
default['vroozi']['name'] = "Default-Attr-in-attr-file"








