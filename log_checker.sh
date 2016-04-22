#!/bin/bash
logs="/var/log/messages
/var/log/eas
/opt/apache-tomcat/logs"
server_list=list.txt

for i in `cat $server_list`
do
	for log in $logs
	do
		check=$(ssh $i ls -al $log 2>/dev/null | wc -l)
		if [ $check -lt 1 ]; then
			echo $i does not have $log
		fi
	done
done
