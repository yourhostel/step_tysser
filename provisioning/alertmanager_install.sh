#!/bin/bash

# Завантажуємо і розпаковуємо Alert Manager
wget https://github.com/prometheus/alertmanager/releases/download/v0.21.0/alertmanager-0.21.0.linux-amd64.tar.gz
tar xvf alertmanager-0.21.0.linux-amd64.tar.gz

# Створюємо користувача alertmanager, якщо він ще не створений
id -u alertmanager &>/dev/null || sudo useradd --no-create-home --shell /bin/false alertmanager

# Створюємо необхідні директорії
sudo mkdir -p /etc/alertmanager /var/lib/alertmanager

# Встановлюємо права доступу
sudo chown -R alertmanager:alertmanager /etc/alertmanager /var/lib/alertmanager
sudo chmod -R 755 /etc/alertmanager /var/lib/alertmanager

# Копіюємо виконувані файли та приклад конфігурації
sudo cp alertmanager-0.21.0.linux-amd64/alertmanager /usr/local/bin/
sudo cp alertmanager-0.21.0.linux-amd64/amtool /usr/local/bin/

# Створюємо базовий конфігураційний файл для Alert Manager
cat <<EOF | sudo tee /etc/alertmanager/alertmanager.yml
global:
  smtp_smarthost: '${ALERTMANAGER_SMTP_SMARTHOST}'
  smtp_from: '${ALERTMANAGER_SMTP_FROM}'
  smtp_auth_username: '${ALERTMANAGER_SMTP_AUTH_USERNAME}'
  smtp_auth_password: '${ALERTMANAGER_SMTP_AUTH_PASSWORD}'
  smtp_require_tls: ${ALERTMANAGER_SMTP_REQUIRE_TLS}

route:
  group_by: ['alertname']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 1h
  receiver: 'email_receiver'

receivers:
- name: 'email_receiver'
  email_configs:
  - to: '${ALERTMANAGER_RECEIVER_EMAIL}'
    send_resolved: true
EOF

# Створюємо systemd сервіс файл для Alert Manager
cat <<EOF | sudo tee /etc/systemd/system/alertmanager.service
[Unit]
Description=Prometheus Alert Manager
Wants=network-online.target
After=network-online.target

[Service]
User=alertmanager
Group=alertmanager
Type=simple
ExecStart=/usr/local/bin/alertmanager \
    --config.file=/etc/alertmanager/alertmanager.yml \
    --storage.path=/var/lib/alertmanager/

[Install]
WantedBy=multi-user.target
EOF

# Перезавантажуємо демон systemd, включаємо та запускаємо Alert Manager
sudo systemctl daemon-reload
sudo systemctl enable alertmanager
sudo systemctl start alertmanager