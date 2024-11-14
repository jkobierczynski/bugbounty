#!/bin/sh
DIR=$1
DOMAIN=$2
DATE="$(date -u +%Y%m%d)"

if [ -z $DIR ] || [ -z $DOMAIN ] || [ -z $DATE ]; 
then
	echo 'USAGE: ./assetfinder <directory> <domain>'
	exit 1
fi

echo "-- Dir = $DIR" > $DIR/assetfinder-$DOMAIN-$DATE.txt
echo "-- Domain = $DOMAIN" >> $DIR/assetfinder-$DOMAIN-$DATE.txt
echo "-- Date = $DATE" >> $DIR/assetfinder-$DOMAIN-$DATE.txt

sudo /home/user/go/bin/assetfinder --subs-only $DOMAIN | sort -u >> $DIR/assetfinder-$DOMAIN-$DATE.txt

