#!/bin/bash

# Установка Prometheus
wget https://github.com/prometheus/prometheus/releases/download/v2.26.0/prometheus-2.26.0.linux-amd64.tar.gz
tar xvf prometheus-2.26.0.linux-amd64.tar.gz

# Створення користувача Prometheus, якщо він не існує
id -u prometheus &>/dev/null || sudo useradd --no-create-home --shell /bin/false prometheus

# Створення каталогів та встановлення прав
sudo mkdir -p /etc/prometheus /var/lib/prometheus
sudo chown -R prometheus:prometheus /etc/prometheus /var/lib/prometheus
sudo chmod -R 775 /etc/prometheus /var/lib/prometheus

# Копіювання виконуваних файлів та шаблонів
sudo cp prometheus-2.26.0.linux-amd64/prometheus /usr/local/bin/
sudo cp prometheus-2.26.0.linux-amd64/promtool /usr/local/bin/
sudo cp -r prometheus-2.26.0.linux-amd64/consoles /etc/prometheus
sudo cp -r prometheus-2.26.0.linux-amd64/console_libraries /etc/prometheus

# Створення основного конфігураційного файлу Prometheus
cat <<EOF | sudo tee /etc/prometheus/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node_exporter'
    static_configs:
      - targets: ['192.168.88.241:9100']

  - job_name: 'mysql_exporter'
    static_configs:
      - targets: ['192.168.88.241:9104']
EOF

# Створення systemd сервісу для Prometheus
cat <<EOF | sudo tee /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
    --config.file /etc/prometheus/prometheus.yml \
    --storage.tsdb.path /var/lib/prometheus/ \
    --web.console.templates=/etc/prometheus/consoles \
    --web.console.libraries=/etc/prometheus/console_libraries

[Install]
WantedBy=multi-user.target
EOF

# Перезавантаження daemon та запуск сервісу
sudo systemctl daemon-reload
sudo systemctl enable prometheus
sudo systemctl start prometheus
