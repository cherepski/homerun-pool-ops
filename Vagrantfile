# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "CentOS-6.4"

  # 64-bit
  config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-x86_64-v20130427.box"

  # 32-bit
  # config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-i386-v20130427.box"

  config.vm.network :private_network, ip: "10.1.0.7"
  config.vm.synced_folder "../homerun-pool", "/srv/www/homerun-pool", owner: "vagrant", group: "vagrant", mount_options: ["dmode=777","fmode=777"]

  config.vm.provision :chef_solo do |chef|
    chef.json = {
        "postgresql" => {
	    "password" => {
	        "postgres" => "mKyH5taev2CpsXp"
	    }
	}
    }
    chef.add_recipe "apache2"
    chef.add_recipe "apache2::mod_wsgi"
    chef.add_recipe "openssl"
    chef.add_recipe "postgresql"
    chef.add_recipe "postgresql::ruby"
    chef.add_recipe "postgresql::server"
    chef.add_recipe "database"
    chef.add_recipe "database::mysql"
    chef.add_recipe "python"
    chef.add_recipe "homerun-pool"
  end

end
