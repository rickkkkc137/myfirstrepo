#!/bin/bash

spark_nodes=""

zoo_nodes=""

#for i in $spark_nodes
#do
#	ssh $i "sudo groupadd spark; sudo useradd --create-home -g spark --password spark spark; sudo passwd spark; sudo su -c \"echo 'spark ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/01_spark\"; sudo su - spark -c \"ssh-keygen\";"
#done

master_key=$(ssh "sudo su - spark -c \"cat ~/.ssh/id_rsa.pub\"")

for i in $zoo_nodes
do
	ssh zookeeper@$i "echo $master_key >> /home/zookeeper/.ssh/authorized_keys"
done
