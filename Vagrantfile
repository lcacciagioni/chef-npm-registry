# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.hostname = "npm-registry-berkshelf"
  config.vm.network :forwarded_port, guest: 5984, host: 5984
  config.vm.box = "lucid32"
  config.vm.box_url = "http://files.vagrantup.com/lucid32.box"
  config.vm.network :private_network, ip: "33.33.33.10"
  config.ssh.max_tries = 40
  config.ssh.timeout   = 120
  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      "couch_db" => {
        "config" => {
          "couchdb" => {
            "database_dir" => "/usr/local/var/lib/couchdb",
            "view_index_dir" => "/usr/local/var/lib/couchdb"
          },
          "httpd" => {
            "bind_address" => "0.0.0.0",
            "secure_rewrites" => false
          }
        }
      },
      "npm_registry" => {
        "couchdb" => {
          "couch" => "/usr/local/var/lib/couchdb/registry.couch"
        }
      }
    }
    chef.run_list = [
      "recipe[apt]",
      "recipe[couchdb::source]",
      "recipe[git]",
      "recipe[nodejs::install_from_binary]",
      "recipe[npm_registry]"
    ]
  end
end