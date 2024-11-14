#!/bin/sh
DIR=$1
DOMAIN=$2
DATE="$(date -u +%Y%m%d)"

if [ -z $DIR ] || [ -z $DOMAIN ] || [ -z $DATE ]; 
then
        echo 'USAGE: ./assetfinder <directory> <domain>'
        exit 1
fi

echo "-- Dir = $DIR" > $DIR/gau-$DOMAIN-$DATE.txt
echo "-- Domain = $DOMAIN" >> $DIR/gau-$DOMAIN-$DATE.txt
echo "-- Date = $DATE" >> $DIR/gau-$DOMAIN-$DATE.txt

echo $DATE
sudo gau --subs $DOMAIN | cut -d / -f 3 | sort -u > $DIR/gau-$DOMAIN-$DATE.txt
