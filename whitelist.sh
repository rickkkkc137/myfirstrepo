#!/usr/bin/env bash
SERVER=
PORT=8888
DIR=/player/player_platform
OUT=./
VARNISH_ROOT=etc
VARNISH_FILE=$VARNISH_ROOT/varnish/playerplatform.vcl

USAGE () {
	echo "USAGE: $(basename $0) -m <mac> -f <filename if known> -d <output/working directory> -h"
	echo "         -l does a listing of what is on the server: $SERVER"
	echo "         -m is required, and checks are done to ensure valid mac format"
	exit 1
}

while getopts ":f:m:d:hl" opt; do
  case $opt in
    f) FILE=$OPTARG
      ;;
    h)
      USAGE
      ;;
    l)
      LISTING=1
      ;;
    m)
      MAC=$OPTARG
      ;;
    d)
      OUT=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
    :)
      echo "Option -$OPTARG requires an argument."
      exit 1
      ;;
  esac
done

#system validation
! [ `which wget` ] && echo "Please install wget" && exit 1
! [ `which curl` ] && echo "Please install curl" &&  exit 1
! [ `which rpm2cpio` ] && echo "Please install rpm2cpio" && exit 1
! [ `which cpio` ] && echo "Please install cpio" && exit 1

#make sure MAC is specified, and that it is a valid mac format
if [[ -z $MAC ]]; then echo "Must specify mac with -m <mac>"; exit 1; fi
! [ `echo $MAC | grep -E "^.{2}:.{2}:.{2}:.{2}:.{2}:.{2}$"` ] && echo Mac must be in a valid format && exit 1

#list remote files
if [[ -n $LISTING ]]; then
	echo Getting files from $SERVER
        echo
	curl "http://$SERVER:$PORT$DIR/?C=M;O=D" 2>/dev/null | grep varnish | sed 's/<[^>]*>//g' | awk '{print $1}'
	exit 1
fi

#find most recent rpm if file not specified
[ -z $FILE ] && FILE=$(curl "http://viper-releases.viperx.org:8888/player/player_platform/?C=M;O=D" 2>/dev/null | grep varnish | head -1 | sed 's/<[^>]*>//g' | awk '{print $1}')
echo $FILE
if [[ ! "$FILE" =~ .*rpm.* ]] || [[ ! "$FILE" =~ .*varnish.* ]]; then echo $FILE is not an rpm or not a varnish file; exit 1; fi
echo
wget --directory-prefix=$OUT http://$SERVER:$PORT$DIR/$FILE 2>/dev/null || echo Unable to connect or unable to find file on server
cd $OUT && rpm2cpio $OUT/$FILE 2>/dev/null | cpio -id 2>/dev/null && cd - 1>/dev/null

#check for MAC 
if [ $(cat $OUT/$VARNISH_FILE | grep -i req.http.mac | grep $MAC | wc -l) -gt 0 ]; then
	echo Mac is in address list
else
	echo Mac is not in address list
fi

#remove stuff
rm -rf $OUT/$FILE $OUT/$VARNISH_ROOT
