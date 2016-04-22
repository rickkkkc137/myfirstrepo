#!/bin/bash

spark_nodes=""

for i in $spark_nodes 
do 
	key=$(ssh $i "sudo su - spark -c \"cat ~/.ssh/id_rsa.pub\"")
	for j in $spark_nodes 
	do 
		ssh $j "sudo su - spark -c \"chmod 700 ~/.ssh/authorized_keys\";sudo su - spark -c \"echo '$key' >> ~/.ssh/authorized_keys\""
	done
done
