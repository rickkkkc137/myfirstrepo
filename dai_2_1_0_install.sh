#!/bin/bash

#host lists
mongo_hosts=mongo
pois_hosts=pois
cis_hosts=cis
ids_hosts=
mgt_hosts=
esp_hosts=
acs_hosts=
acr-slc_hosts=
acr-gw_hosts=
all_hosts=cat_hosts

#system/application config files
sysctl=/etc/sysctl.conf
limits=/etc/security/limits.conf
90nproc=/etc/security/limits.d/90-nproc.conf
hosts=/etc/hosts

#checks/appends
sysctl_entries="net.core.optmem_max=20480 net.core.wmem_default=135168 net.core.wmem_max=135168 net.core.rmem_default=135168 net.core.rmem_max=135168 fs.file-max=64000"
limits_entries[1]="soft nofile 64000"
limits_entries[2]="hard nofile 64000"
limits_entries[3]="soft nproc 32000"
limits_entries[4]="hard nproc 32000"
hosts_entries=""

#func to check config files for correct entries, and fix if they dont exist
check_system_configs () {

for i in `cat $all_hosts`
do
	#add sysctl entries to the hosts
	for entry in $sysctl_entries
	do
		#split the values, fix based on what we find on the server
		value=$(echo $entry | cut -d= -f2)
		entry=$(echo $entry | cut -d= -f1)
		check_entry=$(ssh $i "cat $sysctl | grep $entry" | wc -l)
		if [ $check_entry -lt 1 ]; then
			#entry does not exist in file, so add it
			ssh $i "echo $entry=$value >> $sysctl"
		else
			#entry exists ensuring value is correct
			check_value=$(ssh $i "cat $sysctl | grep $entry | grep $value" | wc -l)
			if [ $check_value -lt 1 ]; then
				#change value if not correct, otherwise entry is fine
				replace="sed -i 's/${entry} = [0-9]*/${entry} = ${value}/g' $sysctl"
				ssh $i $replace
			fi
		fi
	done

	#add /etc/security/limits.conf entries
	for index in 1 2 3 4
	do
		check_entry=$(ssh $i "cat $limits | grep \"^${limits_entries[index]}\"" | wc -l)
	done
	
done

} #end check_system_configs
