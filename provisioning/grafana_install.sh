#!/bin/bash

# Установка Grafana
echo "Установка Grafana..."

# Додавання репозиторію Grafana та ключа GPG
curl https://packages.grafana.com/gpg.key | sudo apt-key add -
echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list

# Оновлення списку пакетів та встановлення Grafana
sudo apt-get update
sudo apt-get install -y grafana

# Налаштування облікових даних адміністратора
sudo sed -i 's/;admin_user = admin/admin_user = tysser/' /etc/grafana/grafana.ini
sudo sed -i 's/;admin_password = admin/admin_password = 1234/' /etc/grafana/grafana.ini

# Запуск Grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

echo "Grafana встановлена та запущена."