require 'rubygems'
require 'pp'
require 'rest_client'
require 'faraday'
require 'json'
require 'time'

ssl_options = {
 client_cert: OpenSSL::X509::Certificate.new(File.read('gold.pub.pem')),
 client_key:  OpenSSL::PKey::RSA.new(File.read('gold.priv.pem')),
 ca_file: 'gold.ca.pem',
 verify: false
}
conn = Faraday.new(url: 'https://pbd.ccp.xcal.tv:8081', ssl: ssl_options) do |faraday|
 faraday.request  :url_encoded             # form-encode POST params
 faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
end
ip_array=[]
response = conn.get '/v3/nodes'
pbd_nodes = (JSON.parse(response.body)).select{|x| (x.has_key? 'name' and !x['name'].nil? and (x['name'].to_s.downcase).match(/#{(ARGV[0].to_s.downcase)}.*/) and x.has_key? 'catalog_timestamp' and !x['catalog_timestamp'].nil? ) and  (Time.now -  Time.parse(x['catalog_timestamp'])) < 7200}.map{|x| x['name']}
for x in pbd_nodes
  response_facts = conn.get "/v3/nodes/#{x}/facts"
  JSON.parse(response_facts.body).each  { |x|
    if /ipaddress_eth0/.match(((x['name']).to_s).downcase)
      puts x['value'].to_s #x['certname'].to_s  + "-"  + x['value'].to_s
    end
  }
end
