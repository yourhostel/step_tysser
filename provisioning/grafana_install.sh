#!/bin/bash

# Установка Grafana
echo "Установка Grafana..."

# Додавання репозиторію Grafana та ключа GPG
curl https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# Оновлення списку пакетів та встановлення Grafana
sudo apt-get update
sudo apt-get install -y grafana

# Створення конфігураційного файлу джерела даних для Prometheus
sudo bash -c 'cat <<EOF > /etc/grafana/provisioning/datasources/prometheus-datasource.yaml
apiVersion: 1

datasources:
- name: Prometheus
  type: prometheus
  access: proxy
  orgId: 1
  url: http://localhost:9090
  isDefault: true
  editable: true
EOF'

# Створення файлу конфігурації джерела даних MySQL Exporter
sudo bash -c 'cat <<EOF > /etc/grafana/provisioning/datasources/mysql-exporter-datasource.yaml
apiVersion: 1

datasources:
- name: MySQL Exporter
  type: prometheus
  access: proxy
  orgId: 1
  url: http://192.168.88.241:9104/metrics
  isDefault: false
  editable: true
EOF'

# Налаштування облікових даних адміністратора
export GF_SECURITY_ADMIN_USER=admin
export GF_SECURITY_ADMIN_PASSWORD=1234

# Запуск Grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

echo "Grafana установлена и запущена."