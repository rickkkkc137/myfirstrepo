#!/bin/bash

input_file=./v6-v4map.txt
v4_addr=$(cat $input_file | cut -d" " -f2)
network=/etc/sysconfig/network
net_script=/etc/sysconfig/network-scripts/ifcfg-eth0

for i in $v4_addr
do
	echo v4addr is $i
	v6_addr=$(cat $input_file | grep $i | cut -d" " -f1)
	hostname=$(ssh $i "hostname")
	ssh $i "sudo sed -i '/HOSTNAME=$hostname/a NETWORKING_IPV6=yes' $network; sudo sed -i '/PEERDNS=no/a IPV6INIT=yes\nIPV6ADDR=$v6_addr/64\nIPV6_DEFAULTGW=2001:558:270:75:96:114:21:129' $net_script; sudo service network restart"
	test=$(ssh $i "/sbin/ifconfig -a | grep $v6_addr | wc -l") 
	if [ $test -ne 1 ]; then
		echo "Something went wrong"
		exit 1
	fi
done

sed '/PEERDNS=no/a IPV6INIT=yes' /etc/sysconfig/network-scripts/ifcfg-eth0
