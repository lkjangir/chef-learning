#install ElastciSearch from RPM which is placed on S3

execute 'download_elasticsearch' do
  command "wget https://download.elastic.co/elasticsearch/release/org/elasticsearch/distribution/rpm/elasticsearch/2.3.1/elasticsearch-2.3.1.rpm"
  action :run
  creates '/tmp/elasticsearch-2.3.1.rpm'
  cwd '/tmp/'
end

ruby_block 'run-from-ruby-block' do
  block do
    Chef::Log.logger 
  end
end

execute 'install_elasticseatch' do
  command  'yum install /tmp/elasticsearch-2.3.1.rpm -y'
  not_if 'rpm -q elasticsearch-2.3.1'
  notifies :restart, 'service[elasticsearch]', :immediately
end

#execute 'update-elasticsearch-conf' do
#  command 'a=$(grep network.host /etc/elasticsearch/elasticsearch.yml) && sed -i "s/$a/network.host: [ \"_local_\" ]/g" /etc/elasticsearch/elasticsearch.yml'
#  action :run
#end

service 'elasticsearch' do
  action [:nothing, :enable]
end

execute 'hold_until_el_comes_back' do
  command 'until [[ $(nc -z localhost 9200) ]]; do echo waiting for elasticsearch to come up && sleep 2;done'
  action :run
end

execute 'install_python_pip' do
  command 'yum install -y python-pip'
  action :run
end

execute 'install_mongo_connector' do
  command "pip install 'mongo-connector[elastic2]'"
  action :run
end

execute 'install_doc_manager' do
  command 'pip install elastic2-doc-manager'
  action :run
end

execute 'install_elasticseatch_ui' do
  command '/usr/share/elasticsearch/bin/plugin install mobz/elasticsearch-head'
  action :run
  creates '/usr/share/elasticsearch/plugins/head'
end

ruby_block 'create_vroozi_index' do
  block do
    require 'net/http'
    require 'uri'
    require 'json'

    uri = URI.parse("http://localhost:9200/vroozi")
    request = Net::HTTP::Put.new(uri)
    request.content_type = "application/json"
    request.body = JSON.dump({
                 "settings" => {
                     "index" => {
                         "number_of_shards" => 5,
                         "number_of_replicas" => 1
                     }
                 }
             })

    response = Net::HTTP.start(uri.hostname, uri.port ) do |http|
      http.request(request)
    end
    puts response.code
    puts response.body
    sleep 10
  end
end

ruby_block 'change_vroozi_settings' do
  block do
    require 'net/http'
    require 'uri'
    require 'json'
    require 'logger'

    close_uri = URI.parse("http://localhost:9200/vroozi/_close")
    close_req = Net::HTTP::Post.new(close_uri)

    uri = URI.parse("http://localhost:9200/vroozi/_settings")
    request = Net::HTTP::Put.new(uri)
    request.content_type = "application/json"
    request.body = JSON.dump({
      "analysis" => {
        "filter" => {
          "ngram_filter" => {
            "type" => "ngram",
            "min_gram" => "2",
            "max_gram" => "20"
          },
          "edge_ngram_filter" => {
            "type" => "edge_ngram",
            "min_gram" => "2",
            "max_gram" => "20"
          }
        },
        "analyzer" => {
          "ngram_filter_analyzer" => {
            "type" => "custom",
            "filter" => [
              "lowercase",
              "ngram_filter"
            ],
            "tokenizer" => "whitespace"
          },
          "edge_ngram_filter_analyzer" => {
            "type" => "custom",
            "filter" => [
              "lowercase",
              "edge_ngram_filter"
            ],
            "tokenizer" => "whitespace"
          },
          "search_analyzer_whitespace" => {
            "type" => "custom",
            "filter" => [
              "lowercase"
            ],
            "tokenizer" => "whitespace"
          }
        }
      }
    })

    
    logger = Logger.new(STDOUT)

    logger.info('Closing index before updating settings')
    
    close_response = Net::HTTP.start(close_uri.hostname, close_uri.port) do |http|
      http.request(close_req)
    end
    logger.debug(close_response.code)
    logger.debug(close_response.body)
    sleep 5
    logger.info('Updating index settings')
    
    response = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(request)
    end
    logger.debug(response.code)
    logger.debug(response.body)
  end
end

ruby_block 'update_vroozi_mappings' do
  block do
    require 'net/http'
    require 'uri'
    require 'json'
    require 'logger'
    
    uri = URI.parse('http://localhost:9200/vroozi/wbs_elements/_mapping')
    request = Net::HTTP::Put.new(uri)
    request.content_type = "application/json"
    request.body = JSON.dump({
      "wbs_elements"=> {
        "properties"=> {
          "code"=> {
            "type"=>            "string",
            "index_options"=> "offsets",
            "analyzer"=>  "ngram_filter_analyzer", 
            "search_analyzer"=> "search_analyzer_whitespace" 
            },
            "description"=> {
              "type"=>            "string",
              "index_options"=> "offsets",
              "analyzer"=>  "edge_ngram_filter_analyzer", 
              "search_analyzer"=> "search_analyzer_whitespace" 
            }
          }
        }
    })
    sleep 2
    logger = Logger.new(STDOUT)
    logger.info('Updating mappings for wbs_elements/_mapping')

    response = Net::HTTP.start(uri.hostname, uri.port) do |http|
      http.request(request)
    end

    logger.debug(response.code)
    logger.debug(response.body)
  end
end

execute 'open_vroozi_index' do
  command "curl -X POST http://localhost:9200/vroozi/_open"
  action :run
end

execute 'mongo-connector-load-data' do
  command "nohup /usr/local/bin/mongo-connector -a #{node['mongodb']['username']} -p #{node['mongodb']['password']} -m localhost:27017 -t localhost:9200 -d elastic2_doc_manager --logfile /var/log/mongo-connector.log -n vroozi.wbs_elements -i _id,unitId,code,description,companyCode,companyCodeId,deleted,active,dateCreated,lastUpdated &"
  action :run
end
