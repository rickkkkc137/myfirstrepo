#!/bin/bash

#vars and shtuff
servers=list
warfile=/home/xdeploy/eas.war
tomcat_deploy_dir=/opt/apache-tomcat/easdeploy
curfile=$tomcat_deploy_dir/eas.war
bakfile=$tomcat_deploy_dir/eas.bak

for i in $servers
do
	ssh $i "sudo cp $curfile $bakfile; sudo cp -f $warfile $tomcat_deploy_dir; sudo service apache-tomcat stop"
	pidoftomcat=$(ssh $i "ps -ef | grep tomcat | grep -v grep" 2>/dev/null | awk '{print $2}')
	if [ -n $check_tomcat_shut ]; then
		ssh $i "kill -9 $pidoftomcat"
	fi
	ssh $i "sudo service apache-tomcat start"
done
