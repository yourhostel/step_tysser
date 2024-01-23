#!/bin/bash

# Установка Grafana
echo "Установка Grafana..."

# Додавання репозиторію Grafana та ключа GPG
sudo apt-get install -y software-properties-common
sudo add-apt-repository "deb https://packages.grafana.com/oss/deb stable main"
wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -

Оновлення списку пакетів та встановлення Grafana
sudo apt-get update
sudo apt-get install -y grafana

# Обновление списка пакетов и установка Grafana
sudo systemctl enable grafana-server
sudo systemctl start grafana-server

echo "Grafana установлена и запущена."