require 'dotenv'
#Завантаження змінного середовища з файлу .env
Dotenv.load

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"

  config.vm.define "vm1" do |vm1|
      vm1.vm.hostname = "vm1"
      # прокидаємо міст у фізичну локальну мережу та харкордим mac
      # для встановлення статики в маршрутизаторі мережі, теж робимо і для VM2
      vm1.vm.network "public_network", bridge: "eno1", mac: "080027D14C66"

      # Встановлення пароля для користувача ubuntu зі змінної оточення SSH_PASSWORD_VM1
      vm1.ssh.username = "ubuntu"
      vm1.ssh.password = ENV['SSH_PASSWORD_VM1']
    # Налаштування для провіженінга, наприклад, shell скрипти
  end

  config.vm.define "vm2" do |vm2|
      vm2.vm.hostname = "vm2"
      vm2.vm.network "public_network", bridge: "eno1", mac: "080027D14C67"

      # Встановлення пароля для користувача ubuntu зі змінної оточення SSH_PASSWORD_VM2
      vm2.ssh.username = "ubuntu"
      vm2.ssh.password = ENV['SSH_PASSWORD_VM2']
    # Налаштування для провіженінга, наприклад, shell скрипти
  end

  # Загальні налаштування, застосовні до обох машин, якщо потрібні
end
