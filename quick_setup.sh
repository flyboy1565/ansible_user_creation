#!/bin/bash

SETUP_FLAG="~/.setup"

if [ ! -e $SETUP_FLAG ]; then 
sudo rm -rf ansible/group_vars
sudo rm -rf ansible/playbooks
sudo rm -rf ansible/roles
sudo ln -s /vagrant/ansible/roles ansible/roles
sudo ln -s /vagrant/ansible/playbooks ansible/playbooks
sudo ln -s /vagrant/ansible/group_vars ansible/group_vars
sudo cp ansible/playbooks/setup.yml ansible/
echo "ansible-playbook -i vagrant_dev setup.yml" | sudo tee -a ~/.bash_history

ssh-keygen -b 2048 -t rsa -f /home/vagrant/.ssh/id_rsa -q -N ""

for val in controller node1 node2 db; do 
	echo "-------------------- COPYING KEY TO ${val^^} NODE ------------------------------"
	sshpass -p 'vagrant' ssh-copy-id -o "StrictHostKeyChecking=no" vagrant@$val.homelab.com 
done

PROJECT_DIRECTORY="/home/vagrant/ansible/"

mkdir -p $PROJECT_DIRECTORY
cd $PROJECT_DIRECTORY



# Creating the inventory file for all 3 nodes to run some adhoc command.

echo -e "[controller]\ncontroller ansible_connection=local\n\n[nodes]\nnode1\nnode2\n\n[db]\ndb" > inventory
echo -e "[defaults]\ninventory = inventory\ninterpreter_python=/usr/bin/python3" > ansible.cfg
echo -e "-------------------- RUNNING ANSBILE ADHOC COMMAND - UPTIME ------------------------------"
echo

# running adhoc command to see if everything is fine

ansible all -i vagrant_dev -m "shell" -a "uptime"
echo
touch $SETUP_FLAG
echo "Setup"| sudo tee -a $SETUP_FLAG

else 
    echo "Setup has been run"

fi

