#!/bin/bash
set +x

output_file=sendme.txt
cat /dev/null > $output_file

slr_hosts=""

com_core=""

for i in $slr_hosts
do
	util=$(ssh $i "free | awk 'FNR == 3 {print \$3/(\$3+\$4)*100}'")
	slr_array+=($i:$util)	
done

for i in $com_core
do
        util=$(ssh $i "free | awk 'FNR == 3 {print \$3/(\$3+\$4)*100}'")
        core_array+=($i:$util)
done

echo "memory util report:" >> $output_file
echo "host - % util" >> $output_file
echo >> $output_file
echo "SLR Hosts:" >> $output_file 
for memhost in "${slr_array[@]}"
do
	KEY="${memhost%%:*}"
	VALUE="${memhost##*:}"
	printf "%s - %s%%\n" "$KEY" "$VALUE" >> $output_file
done
echo >> $output_file
echo "Comcast Vex Core:" >> $output_file
for memhost in "${core_array[@]}"
do
        KEY="${memhost%%:*}"
        VALUE="${memhost##*:}"
        printf "%s - %s%%\n" "$KEY" "$VALUE" >> $output_file
done

mailx -s "Vex Memory Usage `date`" robert_jackson9@cable.comcast.com dennis_bray@cable.comcast.com < $output_file

rm -rf $output_file
