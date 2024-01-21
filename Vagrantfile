Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-20.04"

  config.vm.define "vm1" do |vm1|
    vm1.vm.hostname = "vm1"
    vm1.vm.network "private_network", ip: "192.168.88.10", mac: "080027D14C66"
    # Налаштування для провіженінга, наприклад, shell скрипти
  end

  config.vm.define "vm2" do |vm2|
    vm2.vm.hostname = "vm2"
    vm2.vm.network "private_network", ip: "192.168.88.11", mac: "080027D14C67"
    # Налаштування для провіженінга, наприклад, shell скрипти
  end

  # Загальні налаштування, застосовні до обох машин, якщо потрібні
end
