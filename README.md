# OpensipsStats-2-InfluxDB
Scripts for pushing data from opensips management interface to influxdb. Makes use of the mi_datagram module in opensips.

There are 2 scripts available.
datagram_statistics.rb
This scripts reads output from the get_statistics all command in opensips and pushes all values to the defined influxdb instance.

datagram_ratelimit.rb
This scripts reads out from the rl_list command and pushes the values to the defined influxdb instance.

