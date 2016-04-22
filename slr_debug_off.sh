#!/bin/bash
base_dir=/Users/rjacks005c
slr_nodes=$base_dir/dirs-po-prod-slr.txt

for i in `cat $slr_nodes`
do
        ssh $i "sudo puppet agent --enable; sudo puppet agent -t"
done
