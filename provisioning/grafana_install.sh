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
  url: 192.168.88.241:9100
  isDefault: true
  editable: true
EOF'

# Створення папок для дашбордів
sudo mkdir -p /etc/grafana/provisioning/dashboards
sudo mkdir -p /var/lib/grafana/dashboards

# Копіювання JSON-файлів дашбордів із спільної папки
sudo cp /vagrant/dashboards/*.json /var/lib/grafana/dashboards/

# Додавання конфігураційного файлу для автоматичного надання дашбордів
sudo bash -c 'cat <<EOF > /etc/grafana/provisioning/dashboards/dashboard-providers.yaml
apiVersion: 1

providers:
- name: "default"
  orgId: 1
  folder: ""
  type: file
  disableDeletion: false
  editable: true
  options:
    path: /var/lib/grafana/dashboards
EOF'

# Налаштування облікових даних адміністратора
sudo sed -i 's/;admin_user = admin/admin_user = tysser/' /etc/grafana/grafana.ini
sudo sed -i 's/;admin_password = admin/admin_password = 1234/' /etc/grafana/grafana.ini

# Запуск Grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

echo "Grafana встановлена та запущена."