#!/bin/bash

# Установка утиліт, необхідних для завантаження та розпакування файлів
sudo apt-get install -y wget tar

# Завантаження та встановлення Prometheus mysql exporter
VERSION="0.15.1"
# PASSWORD=$(cat /vagrant/.env | grep PASSWORD | cut -d '=' -f2)
source /vagrant/.env
wget https://github.com/prometheus/mysqld_exporter/releases/download/v${VERSION}/mysqld_exporter-${VERSION}.linux-amd64.tar.gz
tar xvzf mysqld_exporter-${VERSION}.linux-amd64.tar.gz
sudo cp mysqld_exporter-${VERSION}.linux-amd64/mysqld_exporter /usr/local/bin/
sudo chmod +x /usr/local/bin/mysqld_exporter

# Створення користувача для експортера
    sudo mysql -uroot -p$PASSWORD -e "CREATE USER 'exporter' IDENTIFIED BY '$PASSWORD'; GRANT PROCESS, REPLICATION CLIENT, SELECT ON *.* TO 'exporter';"

# Створення конфігураційного файлу експортера
echo "[client]
user=exporter
password=$PASSWORD" | sudo tee /etc/mysql/exporter.cnf

# Створення systemd сервісу для експортера
echo '[Unit]
Description=Prometheus MySQL Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=root
Group=root
Type=simple
ExecStart=/usr/local/bin/mysqld_exporter --config.my-cnf=/etc/mysql/exporter.cnf

[Install]
WantedBy=multi-user.target' | sudo tee /etc/systemd/system/mysqld_exporter.service

sudo systemctl daemon-reload
sudo systemctl enable mysqld_exporter
sudo systemctl start mysqld_exporter
