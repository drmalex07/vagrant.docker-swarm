# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'

INVENTORY_FILE = 'hosts.yml'

#
# Parse inventory file
# We need a common inventory referenced by both this Vagrantfile and Ansible playbook.
#

inventory = YAML.load_file(INVENTORY_FILE)
inventory_vars = inventory['all']['vars']
inventory_groups = inventory['all']['children']

#
# Define Vagrant setup
#

Vagrant.configure(2) do |config|

  config.vm.box = "debian/jessie64"
  config.vm.box_check_update = false
  
  config.vm.synced_folder ".", "/vagrant", type: "rsync"

  inventory_groups['workers']['hosts'].keys.each do |worker_name|
    config.vm.define worker_name do |worker|
      h = inventory_groups['workers']['hosts'][worker_name]

      worker.vm.network "private_network", ip: h['ipv4_address']
      worker.vm.provider "virtualbox" do |vb|
        vb.name = h['fqdn']
        vb.memory = 512
      end
    end
  end

  config.vm.define "manager" do |manager|
    h = inventory_groups['manager']['hosts']['manager']

    manager.vm.network "private_network", ip: h['ipv4_address']
    manager.vm.provider "virtualbox" do |vb|
      vb.name = h['fqdn']
      vb.memory = 1024
    end
    
    # Play ansible playbook once (in parallel for all hosts)
    # see https://www.vagrantup.com/docs/provisioning/ansible.html#ansible-parallel-execution
    manager.vm.provision "ansible" do |a| 
      a.playbook = 'play.yml'
      a.limit = 'all'
      a.inventory_path = INVENTORY_FILE
    end
  end


  # Define common provisioning tasks

  config.vm.provision "file", source: "secrets/id_rsa", destination: ".ssh/id_rsa"
  config.vm.provision "shell", path: "copy-key.sh", privileged: false
  
  config.vm.provision "file", source: "profile", destination: ".profile"
  config.vm.provision "file", source: "bashrc", destination: ".bashrc"
  
  #config.vm.provision "file", source: "~/.vimrc", destination: ".vimrc"
  #config.vm.provision "file", source: "~/.vim/", destination: "."

  #config.vm.provision "shell", path: "configure-apt-proxy.sh"
  
  config.vm.provision "shell", path: "install-ansible-prereqs.sh"

end
