require 'dotenv'
#Завантаження змінного середовища з файлу .env
Dotenv.load

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"
  config.vm.synced_folder ".", "/vagrant", type: "virtualbox"
  config.vm.define "vm1" do |vm1|
      vm1.vm.hostname = "vm1"
      # прокидаємо міст у фізичну локальну мережу та харкордим mac
      # для встановлення статики в маршрутизаторі мережі, теж робимо і для VM2
      vm1.vm.network "public_network", bridge: "eno1", mac: "080027D14C66"

      # Встановлення пароля для користувача vagrant зі змінної оточення SSH_PASSWORD_VM1
      vm1.vm.provision "shell", inline: <<-SHELL
        sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
        service ssh restart
      echo "vagrant:#{ENV['SSH_PASSWORD_VM1']}" | chpasswd
      SHELL

      # Запуск скрипта установки MySQL
      vm1.vm.provision "shell", path: "provisioning/mysql_install.sh"

      # Запуск скрипта установки Prometheus MySQL Exporter
      vm1.vm.provision "shell", path: "provisioning/prometheus_mysql_exporter_install.sh"

      # Запуск установки Node Exporter
      vm1.vm.provision "shell", path: "provisioning/node_exporter_install.sh"

  end

  config.vm.define "vm2" do |vm2|
      vm2.vm.hostname = "vm2"
      vm2.vm.network "public_network", bridge: "eno1", mac: "080027D14C67"

      # Встановлення пароля для користувача vagrant зі змінної оточення SSH_PASSWORD_VM2
      vm2.vm.provision "shell", inline: <<-SHELL
        sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/g' /etc/ssh/sshd_config
        service ssh restart
      echo "vagrant:#{ENV['SSH_PASSWORD_VM2']}" | chpasswd
      SHELL

      # Запуск установки Prometheus
      vm2.vm.provision "shell", path: "provisioning/prometheus_install.sh"

      # Запуск установки Alert Manager
      vm2.vm.provision "shell", path: "provisioning/alertmanager_install.sh"
  end

end
