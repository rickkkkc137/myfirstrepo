#!/bin/bash
zoo_nodes=""

master_key=$(ssh  "sudo su - spark -c \"cat ~/.ssh/id_rsa.pub\"")

for i in $zoo_nodes
do
	ssh zookeeper@$i "echo $master_key >> /home/zookeeper/.ssh/authorized_keys"
done
