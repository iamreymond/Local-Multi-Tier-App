Vagrant.configure("2") do |config|
  config.vm.boot_timeout = 600
  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true

  ### Nginx ###

  config.vm.define "web01" do |web01|
    web01.vm.box = "ubuntu/trusty64"
    web01.vm.hostname = "web01"
    web01.vm.network "private_network", ip: "192.168.56.101"
    web01.vm.provider "virtualbox" do |vb|
      vb.gui = true
      vb.memory = "1024"
    end
    web01.vm.provision "shell", path: "nginx.sh"
  end

  ### Tomcat ###
  config.vm.define "app01" do |app01|
    app01.vm.box = "geerlingguy/centos7"
    app01.vm.hostname = "app01"
    app01.vm.network "private_network", ip: "192.168.56.102"
    app01.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
      vb.cpus = 2
    end
    app01.vm.provision "shell", path: "tomcat.sh"
  end

  ### RabbitMQ ###
  config.vm.define "rmq01" do |rmq01|
    rmq01.vm.box = "geerlingguy/centos7"
    rmq01.vm.hostname = "rmq01"
    rmq01.vm.network "private_network", ip: "192.168.56.103"
    rmq01.vm.provision "shell", path: "rabbitmq.sh"
  end

  ### Memcache ###
  config.vm.define "mc01" do |mc01|
    mc01.vm.box = "geerlingguy/centos7"
    mc01.vm.hostname = "mc01"
    mc01.vm.network "private_network", ip: "192.168.56.104"
    mc01.vm.provision "shell", path: "memcached.sh"
  end

  ### MySQL ###
  config.vm.define "db01" do |db01|
    db01.vm.box = "geerlingguy/centos7"
    db01.vm.hostname = "db01"
    db01.vm.network "private_network", ip: "192.168.56.105"
    db01.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end
    db01.vm.provision "shell", path: "mysql.sh"
  end
end

