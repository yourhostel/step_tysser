#!/bin/bash

sudo apt-get update

# Установка MySQL Server без взаємодії з користувачем
source /vagrant/.env
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
sudo apt-get install -y mysql-server

# Налаштування MySQL для прослуховування на всіх інтерфейсах
sudo sed -i 's/bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

# Перевірка існування користувача 'exporter'
user_exists=$(sudo mysql -uroot -p$PASSWORD -sse "SELECT COUNT(*) FROM mysql.user WHERE user = 'exporter'")
if [ "$user_exists" -eq 0 ]; then
    echo "User 'exporter' already exists, skipping creation."
    echo "Користувач «exporter» вже існує"
else
    # Створення бази даних та користувача
    sudo mysql -uroot -p$PASSWORD -e "CREATE DATABASE Users; CREATE USER 'exporter' IDENTIFIED BY '$PASSWORD'; GRANT ALL PRIVILEGES ON Users.* TO 'exporter'; FLUSH PRIVILEGES;"
fi
# Перезапуск MySQL для застосування змін
sudo service mysql restart
