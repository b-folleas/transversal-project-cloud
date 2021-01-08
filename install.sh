#!bin/bash

# MOSQUITTO
apt update
apt -y install gnupg wget mosquitto mosquitto-clients

# TELEGRAF
wget -qO- https://repos.influxdata.com/influxdb.key | apt-key add -
source /etc/lsb-release
echo "deb https://repos.influxdata.com/${DISTRIB_ID,,} ${DISTRIB_CODENAME} stable" | tee /etc/apt/sources.list.d/influxdb.list
apt update
apt -y install telegraf
telegraf config > telegraf.conf

# INFLUXDB
apt -y install influxdb
influxd -config /etc/influxdb/influxdb.conf

# GRAFANA
apt -y install apt-transport-https
apt -y install software-properties-common
wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | tee -a /etc/apt/sources.list.d/grafana.list
apt -y update
apt -y install grafana

service mosquitto start
rm /var/run/telegraf/telegraf.pid
service telegraf start
service influxdb start
service grafana-server start

service mosquitto status
service telegraf status
service influxdb status
service grafana-server status
