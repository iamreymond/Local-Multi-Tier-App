Vagrant.configure("2") do |config|
  config.vm.define "box01" do |box01|
    box01.vm.box = "ubuntu/trusty64"
    box01.vm.hostname = "box01"
    box01.vm.network "private_network", ip: "192.168.56.11"
    box01.vm.synced_folder ".", "/vagrant"
  end

  config.vm.define "box02" do |box02|
    box02.vm.box = "ubuntu/trusty64"
    box02.vm.hostname = "box02"
    box02.vm.network "private_network", ip: "192.168.56.12"
    box02.vm.synced_folder ".", "/vagrant"
  end

  config.vm.define "box03" do |box03|
    box03.vm.box = "ubuntu/trusty64"
    box03.vm.hostname = "box03"
    box03.vm.network "private_network", ip: "192.168.56.13"
    box03.vm.synced_folder ".", "/vagrant"
  end
end



