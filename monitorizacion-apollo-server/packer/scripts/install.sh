#!/bin/bash
set -e
exec > >(tee -a /var/log/install_apollo_elk.log) 2>&1

start_time=$(date '+%Y-%m-%d %H:%M:%S')

echo "[INFO] Actualizando paquetes..."
sudo apt-get update -y && sudo apt-get upgrade -y

echo "[INFO] Instalando Node.js y npm..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo bash -
sudo apt-get install -y nodejs build-essential

echo "[INFO] Moviendo aplicación Apollo a /opt/apollo"
[ -d /tmp/app ] || { echo "[ERROR] /tmp/app no existe"; exit 1; }
sudo cp -r /tmp/app /opt/apollo
sudo chown -R ubuntu:ubuntu /opt/apollo
cd /opt/apollo

echo "[INFO] Instalando dependencias de Node y compilando..."
sudo npm install
sudo npm run build

echo "[INFO] Instalando y configurando Nginx..."
sudo apt-get install -y nginx
[ -f /tmp/default.conf ] || { echo "[ERROR] /tmp/default.conf no existe"; exit 1; }
sudo cp /tmp/default.conf /etc/nginx/sites-available/default
sudo systemctl enable nginx

echo "[INFO] Instalando Elasticsearch..."
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.17-amd64.deb
sudo dpkg -i elasticsearch-7.17.17-amd64.deb
sudo systemctl enable elasticsearch

echo "[INFO] Configurando Elasticsearch..."
echo "network.host: 0.0.0.0" | sudo tee -a /etc/elasticsearch/elasticsearch.yml
echo "http.port: 9200" | sudo tee -a /etc/elasticsearch/elasticsearch.yml
echo "discovery.type: single-node" | sudo tee -a /etc/elasticsearch/elasticsearch.yml

echo "[INFO] Instalando Kibana..."
sudo systemctl disable kibana || true
wget https://artifacts.elastic.co/downloads/kibana/kibana-7.17.17-amd64.deb
sudo dpkg -i kibana-7.17.17-amd64.deb
sudo systemctl enable kibana

echo "[INFO] Configurando Kibana..."
cat <<EOF | sudo tee /etc/kibana/kibana.yml
server.host: "0.0.0.0"
elasticsearch.hosts: ["http://localhost:9200"]
EOF

echo "[INFO] Instalando Logstash..."
wget https://artifacts.elastic.co/downloads/logstash/logstash-7.17.17-amd64.deb
sudo dpkg -i logstash-7.17.17-amd64.deb
sudo systemctl enable logstash

echo "[INFO] Configurando Logstash..."
sudo tee /etc/logstash/conf.d/apollo.conf > /dev/null <<EOF
input {
  file {
    path => "/opt/apollo/logs/app.log"
    start_position => "beginning"
  }
}

filter {
  grok {
    match => { "message" => "Consulta ejecutada: %{TIMESTAMP_ISO8601:timestamp} \| IP: %{IPORHOST:client_ip} \| Método: %{WORD:method} \| Query: %{GREEDYDATA:query}" }
  }
}

output {
  elasticsearch {
    hosts => ["http://localhost:9200"]
    index => "apollologstash-%{+YYYY.MM.dd}"
  }
}
EOF

echo "[INFO] Instalando APM Server..."
wget https://artifacts.elastic.co/downloads/apm-server/apm-server-7.17.17-amd64.deb
sudo dpkg -i apm-server-7.17.17-amd64.deb
sudo systemctl enable apm-server

echo "[INFO] Configurando APM Server..."
cat <<EOF | sudo tee /etc/apm-server/apm-server.yml
apm-server:
  host: "0.0.0.0:8200"

output.elasticsearch:
  hosts: ["http://localhost:9200"]

setup.kibana:
  host: "localhost:5601"

logging:
  level: info
EOF

echo "[INFO] Instalando Filebeat..."
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.17.17-amd64.deb
sudo dpkg -i filebeat-7.17.17-amd64.deb
sudo systemctl enable filebeat

echo "[INFO] Configurando Filebeat..."
cat <<EOF | sudo tee /etc/filebeat/filebeat.yml
filebeat.inputs:
  - type: log
    enabled: true
    paths:
      - /var/log/*.log
      - /opt/apollo/logs/*.log

output.elasticsearch:
  hosts: ["http://localhost:9200"]

setup.kibana:
  host: "localhost:5601"

logging:
  level: info
EOF

echo "[INFO] Creando carpeta de logs para Apollo..."
sudo mkdir -p /opt/apollo/logs
sudo chown -R ubuntu:ubuntu /opt/apollo/logs

echo "[INFO] Instalando Metricbeat..."
wget https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.17.17-amd64.deb
sudo dpkg -i metricbeat-7.17.17-amd64.deb
sudo systemctl enable metricbeat

echo "[INFO] Configurando Metricbeat..."
cat <<EOF | sudo tee /etc/metricbeat/metricbeat.yml
metricbeat.config.modules:
  path: \${path.config}/modules.d/*.yml
  reload.enabled: false

output.elasticsearch:
  hosts: ["http://localhost:9200"]

setup.kibana:
  host: "localhost:5601"

logging:
  level: info
EOF

sudo metricbeat modules enable system

echo "[INFO] Creando servicio systemd para Apollo Server..."
cat <<EOF | sudo tee /etc/systemd/system/apollo.service
[Unit]
Description=Apollo GraphQL Server
After=network.target elasticsearch.service apm-server.service
Requires=elasticsearch.service apm-server.service

[Service]
ExecStart=/usr/bin/node /opt/apollo/dist/index.js
Restart=always
User=ubuntu
Environment=NODE_ENV=production
WorkingDirectory=/opt/apollo

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable apollo

echo "[INFO] Instalación completa"
echo "Inicio : $start_time - Fin: $(date '+%Y-%m-%d %H:%M:%S')"
