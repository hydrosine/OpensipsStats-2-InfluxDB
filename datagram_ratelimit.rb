#get opensips rl_list information and store it to influxdb.
#v0.1 - version used for opensips summit. Used on opensips version 2.1

require 'opensips/mi'
require 'influxdb'
require 'socket'

hostname = Socket.gethostname

#Configuration for connecting to opensips datagram managemement interface. Change host and port to match yours.
opensips = Opensips::MI.connect :datagram, 
                                :host => "127.0.0.1", 
                                :port => 8080

#Configuration for connecting to influxdb via udp. Change host and port to match yours
influxdb = InfluxDB::Client.new udp: {host: '127.0.0.1', port: 8125}

loop do
 #Get the info from opensips datagram
 rl_list = opensips.command('rl_list')

 puts rl_list.rawdata
 result = [] 
 rl_list.rawdata.each do |element| 
  temp_result = {} 
  element.slice!("PIPE::  ") 
  element.split(" ").each do |kvpair| 
   k, v = kvpair.split("=", 2) 
   temp_result[k] = v 
  end  
 result << temp_result 
 end

 #send the values to influxdb.
 result.each do |datapoint|
  influxdata = {
   values: { value: datapoint['counter'].to_i },
   tags: { id: datapoint["id"], host: hostname }
  }
  influxdb.write_point('rl', influxdata)
 end
 
 #repeat every 5 seconds.
 sleep 5
end
