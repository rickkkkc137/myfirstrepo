#!/bin/bash
zoo_hosts="" 

for i in $zoo_hosts
do
	ssh $i "sudo groupadd zookeeper; sudo useradd --create-home -g zookeeper --password zookeeper zookeeper; sudo passwd zookeeper; sudo mkdir -p /home/zookeeper/.ssh/; sudo chown -R zookeeper:zookeeper /home/zookeeper; sudo chmod 600 /home/zookeeper/.ssh; sudo su - -c 'echo \"zookeeper ALL=(ALL) NOPASSWD: ALL\" > /etc/sudoers.d/01_zookeeper'"
done
