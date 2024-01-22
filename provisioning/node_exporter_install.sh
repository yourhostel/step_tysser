#!/bin/bash
# Завантажуємо Node Exporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.7.0/node_exporter-1.7.0.linux-amd64.tar.gz
# Розпаковуємо архів
tar xvfz node_exporter-1.7.0.linux-amd64.tar.gz

# Переміщаємо файл Node Exporter, що виконується
sudo cp node_exporter-1.7.0.linux-amd64/node_exporter /usr/local/bin

# Створюємо користувача prometheus, якщо він ще не існує
id -u prometheus &>/dev/null || sudo useradd -M -r -s /bin/false prometheus

# Створюємо службу systemd для Node Exporter
echo '[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target' | sudo tee /etc/systemd/system/node_exporter.service

# Перезавантажуємо systemd для читання нової служби
sudo systemctl daemon-reload

# Включаємо та запускаємо Node Exporter
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

