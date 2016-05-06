#get opensips statistics information and store it to influxdb.
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
 statistics = opensips.get_statistics('all')

 #Manipulate the data so its useable for influxdb.
 result = []
 statistics.rawdata.each do |element| 
  k, v = element.split(":: ")
  k1, k2 = k.split(":", 2)
  result << { measure: k1, id: k2, value: v.to_i}
 end

 #Store it to influxdb
 result.each do |datapoint|
  influxdata = {
   values: { value: datapoint[:value] },
   tags: { id: datapoint[:id], host: hostname }
  } 
  influxdb.write_point(datapoint[:measure], influxdata)
 end
 #repeat every 5 seconds.
 sleep 5
end

