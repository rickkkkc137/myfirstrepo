#!/bin/bash
kafka_hosts=""

for i in $kafka_hosts
do
	ssh $i "sudo groupadd kafka; sudo useradd --create-home -g kafka --password kafka kafka; sudo passwd kafka; sudo su - -c 'echo \"kafka ALL=(ALL) NOPASSWD: ALL\" > /etc/sudoers.d/01_kafka'"
done
