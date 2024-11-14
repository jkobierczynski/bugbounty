#!/bin/sh
DIR=$1
FILE=$2
DATE=$3

alias uro='/home/user/.local/share/pipx/venvs/uro/bin/uro'

if [ -z $DATE ]; 
then
	DATE="$(date -u +%Y%m%d)"
fi

if [ -z $DIR ] || [ -z $FILE ] || [ -z $DATE ];
then
        echo 'USAGE: ./uro.sh <directory> <file>'
        exit 1
fi

echo "-- Dir = $DIR" > $DIR/uro-$FILE-$DATE.txt
echo "-- File = $FILE" >> $DIR/uro-$FILE-$DATE.txt
echo "-- Date = $DATE" >> $DIR/uro-$FILE-$DATE.txt

echo $DATE
grep -v href $DIR/gospider-$DATE/$FILE | sed -e 's/^.*http/http/g' | sed -e 's/] - .*$//g' | uro | sort > $DIR/uro-$FILE-$DATE.txt
