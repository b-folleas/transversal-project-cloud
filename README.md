# Configuration de l'image docker : cloud

## Installation depuis une image Ubuntu vierge

```sh
docker rm -f ubuntu && docker run -dit --name=ubuntu ubuntu && docker exec -it ubuntu /bin/bash
apt update && apt -y install nano net-tools && nano install.sh
// copy install.sh
/bin/bash install.sh

netstat -plntu // 8086/8088/3000/1883 en listen
```

## Lancer le container
```sh
// Transformer un container existant en image
docker ps
docker commit container_id new_name

// Run image
docker run -dit -p 1883:1883 -p 3000:3000 --name=new_name docker_hub_name
docker exec -it new_name /bin/bash

// Lancer à partir d un container existant
docker start container_name
docker exec -it new_name /bin/bash

// Push container
docker tag cloud eloiblt/cloud
docker push eloiblt/cloud

// Pull container
docker run -dit -p 1883:1883 -p 3000:3000 --name=cloud eloiblt/cloud
docker exec -it cloud /bin/bash

// Puis relancer les services
service mosquitto start
rm /var/run/telegraf/telegraf.pid
service telegraf start
service influxdb start
service grafana-server start

// Relancer les services en une seule commande
service mosquitto start && rm /var/run/telegraf/telegraf.pid && service telegraf start && service influxdb start && service grafana-server start
```

## Infos

### influxdb : 
ports : 8086 + 8088
```sh
influx
create database telegraf
create user telegraf with password 'root'
show databases
show users
service influxdb restart

influx
show databases
use telegraf
show measurements
select * from mqtt_consumer

tail -f -n 5 /var/log/influxdb/influxd.log
```

### telegraf
```sh
cd /etc/telegraf/
mv telegraf.conf telegraf.conf.default
nano telegraf.conf
// copy telegraf.conf
service telegraf restart

tail -f -n 5 /var/log/telegraf/telegraf.log
```

### grafana
port : 3000
```sh
Add data source > influxdb > 
http://localhost:8086
telegraf
telegraf
root
```

### mosquitto
port : 1883
```sh
mosquitto -p 1883
mosquitto_pub -h localhost -t content -m hello
mosquitto_sub -h localhost -t content

tail -f -n 5 /var/log/mosquitto/mosquitto.log
```