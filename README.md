# OpensipsStats-2-InfluxDB
Scripts for pushing data from opensips management interface to influxdb. Makes use of the mi_datagram module in opensips. This script can be run on multiple boxes all pushing data to the same InfluxDB. 

There are 2 scripts available.

- datagram_statistics.rb
This scripts reads output from the get_statistics all command in opensips and pushes all values to the defined influxdb instance.

- datagram_ratelimit.rb
This scripts reads out from the rl_list command and pushes the values to the defined influxdb instance.

# How to use
Edit the ip/port configuration for opensips mi_datagram and influxdb connection.

Run the script in a screen. so it keeps running even when you close the connection.

# Requirements
ruby and the following gems, use gem install <name> to install.
- influxdb
- opensips-mi

opensips with mi_datagram module loaded and configured. If you want to use the ratelimit script you also need the ratelimit module and related configuration.

Have influxdb installed and configure an UDP listener which pushes data into opensips db. Example configuration block for InfluxDB below.

    [[udp]]
     enabled = true
     bind-address = ":8125"
     database = "opensips"
     #retention-policy = ""

    # These next lines control how batching works. You should have this enabled
    # otherwise you could get dropped metrics or poor performance. Batching
    # will buffer points in memory if you have many coming in.

    batch-size = 5000 # will flush if this many points get buffered
    batch-pending = 10 # number of batches that may be pending in memory
    batch-timeout = "1s" # will flush at least this often even if we haven't hit buffer limit
    read-buffer = 8388608 # UDP Read buffer size, 0 means OS default. UDP listener will fail if set above OS max.```
    
# Other Notes
- Use grafana to draw graphs from the data. You can easily build queries in the interface, Select a measurement ie. shmem and use ID and/or HOST in the where part.
- If you have any suggestions on improving this script or have any questions feel free to open an issue or pull request.
