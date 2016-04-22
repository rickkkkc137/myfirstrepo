#!/bin/bash

if [ $# -lt 2 ]; then
	echo "Not enough args"
	exit 1
fi

while getopts "v:" opt; do
	case $opt in
		v)
			version=$OPTARG
			;;
		*)
			echo "invalid args"
			exit 2
			;;
	esac
done

#set filename based on version provided
filename=eas-mongo-$version.tgz
basedir=/tmp

#wget the mongo file, and check to ensure we grabbed it correctly
wget -P $basedir http://viper-releases.viperx.org/altcon/eas/$version/$filename
if [ $? -ne 0 ]; then
	echo "Something went wrong pulling file, please investigate"
	exit 3
fi

#ensure file exists, and if so untar and begin installation
if [ -f $basedir/$filename ]; then
	tar -xvf $basedir/$filename
	#at this point we want to run 2.0.2/mongo/install-$version.sh
else
	echo "file:$basedir/$filename not found"
	exit 4 
fi
