# Vroozi recipe to fetch JDK from S3 and install on server. 

execute 'remove_java' do
  command 'yum remove java -y'
  action :run
end

execute 'fetch_java' do
  command 'aws s3 cp s3://vroozi-req-software/jdk-8u112-linux-x64.tar.gz /tmp/jdk-8u112-linux-x64.tar.gz'
  creates '/opt/java'
  action :run
end

execute 'extract_java' do
  command 'tar -zxf /tmp/jdk-8u112-linux-x64.tar.gz -C /opt/ && mv /opt/jdk1.8* /opt/java'
  not_if { ::Dir.exist?("/opt/java") }
end

execute 'java_home' do
  command 'echo JAVA_HOME=/opt/java >> /etc/environment'
  not_if 'grep JAVA_HOME /etc/environment'
end

execute 'java_home1' do
  command 'echo JAVA_HOME=/opt/java >> /root/.bashrc'
  not_if 'grep JAVA_HOME /root/.bashrc'
end

execute 'java_path' do
  command "echo 'PATH=\"/opt/java/bin:$PATH\"' >> /root/.bashrc"
  not_if 'grep /opt/java/bin /root/.bashrc'
end

execute 'create-java-symlink' do
  command 'ln -s /opt/java/bin/java /usr/local/bin/java'
  action :run
  not_if '[ -L /usr/local/bin/java ]'
end

execute 'create-java-symlink' do
  command 'ln -s /opt/java/bin/java /usr/bin/java'
  action :run
  not_if '[ -L /usr/bin/java ]'
end

execute 'create-java-alertnatives' do
  command "rm -f /etc/alternatives/java && ln -s /opt/java/bin/java /etc/alternatives/java"
  action :run
  not_if 'ls -al /etc/alternatives/java'
end

