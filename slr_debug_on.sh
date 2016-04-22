#!/bin/bash
base_dir=/Users/rjacks005c
slr_nodes=$base_dir/dirs-po-prod-slr.txt
logback=/usr/local/thistech/tomcat/lib/logback.properties

for i in `cat $slr_nodes`
do
	echo $i
	ssh $i "sudo puppet agent --disable; sudo sed -i 's/debug.enabled=false/debug.enabled=true/g' $logback; sudo service tomcat stop; sudo service tomcat start; sudo tail -f /usr/local/thistech/tomcat/logs/catalina.out"
done
