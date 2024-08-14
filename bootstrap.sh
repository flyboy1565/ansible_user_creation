#!/usr/bin/env bash

sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd

touch /home/vagrant/.hushlogin

echo -e "192.168.56.2 controller.homelab.com controller\n192.168.56.3 node1.homelab.com node1\n192.168.56.4 node2.homelab.com node2\n192.168.56.5 db.homelab.com db" >> /etc/hosts

sudo apt-add-repository ppa:ansible/ansible
sudo apt update && sudo apt -y install curl wget net-tools iputils-ping python3-pip sshpass python3-dev unzip

if [[ $(hostname) = "controller" ]]; then
  sudo apt -y install ansible
  sudo mkdir /etc/ansible
  echo "[controller]" |sudo tee /etc/ansible/hosts
  echo "controller.homelab.com ansible_user=vagrant" |sudo tee -a /etc/ansible/hosts
  echo "[nodes]" |sudo tee -a /etc/ansible/hosts
  echo "node1.homelab.com ansible_user=vagrant" |sudo tee -a /etc/ansible/hosts
  echo "node2.homelab.com ansible_user=vagrant" |sudo tee -a /etc/ansible/hosts
  echo -e "[db]\ndb.homelab.com ansible_user=vagrant" |sudo tee -a /etc/ansible/hosts
  echo -e "[defaults]\ninventory=/etc/ansible/hosts\nhost_key_checking=False\nansible_python_interpreter=/usr/bin/python3"|sudo tee /etc/ansible/ansible.cfg
fi

if [[ $(hostname) = "db" ]]; then
  sudo apt-get install wget ca-certificates
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
  echo "deb http://apt-archive.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list
  # echo "deb https://apt-archive.postgresql.org/pub/repos/apt bionic-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
  sudo apt-get update
  sudo apt-get -y install postgresql-12 postgresql-client-12 libpq-dev python3-dev python3-psycopg2
  sudo systemctl start postgresql@12-main
  sudo pg_ctlcluster 12 main start
fi