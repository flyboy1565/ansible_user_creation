# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do | config |
    
    config.vm.provider "virtualbox" do | vb|
        vb.memory = "1024"
        # vb.memory = "2048"
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    end
    config.vm.box_check_update = false

    config.vm.define "controller" do |controller|
        controller.vm.box = "ubuntu/bionic64"
        controller.vm.hostname="controller.homelab.com"
        controller.vm.network "private_network", ip:"192.168.56.2"
        controller.vm.provision "shell", path: "bootstrap.sh"
        controller.vm.synced_folder  "ansible", "/home/vagrant/ansible", type:"virtualbox"
        # controller.vm.provision "file", source: "key_gen.sh", destination: "/home/vagrant/"
        # controller.vm.provision "file", source: "quick_setup.sh", destination: "/home/vagrant/"
    end

    # config.vm.define "node1" do | node1|
    #     node1.vm.box = "ubuntu/bionic64"
    #     node1.vm.hostname="node1.homelab.com"
    #     node1.vm.network "private_network", ip:"192.168.56.3"
    #     node1.vm.provision "shell", path: "bootstrap.sh"
    # end

    # config.vm.define "node2" do | node2|
    #     node2.vm.box = "ubuntu/bionic64"
    #     node2.vm.hostname="node2.homelab.com"
    #     node2.vm.network "private_network", ip:"192.168.56.4"
    #     node2.vm.provision "shell", path: "bootstrap.sh"
    # end    

    # config.vm.define "db" do | db|
    #     db.vm.box = "ubuntu/bionic64"
    #     db.vm.hostname="db.homelab.com"
    #     db.vm.network "private_network", ip:"192.168.56.5"
    #     db.vm.provision "shell", path: "bootstrap.sh"
    # end    

end
