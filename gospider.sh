#!/bin/sh
DIR=$1
DOMAIN=$2
FILE=$3
DATE="$(date -u +%Y%m%d)"

if [ -z $DIR ] || [ -z $DOMAIN ] || [ -z $FILE ] || [ -z $DATE ]; 
then
        echo 'USAGE: ./gospider <directory> <domain> <file>'
        echo 'directory = client name, company'
	echo 'domain = consolidated domain in scope, will group domains in dir formated gospider-$DOMAIN-$DATE'
	echo 'file = file containing domains of consolidated domain in scope'
        exit 1
fi

if [ -z $USERAGENT ] && [ -z "$HEADER" ];
then
	echo 'No header or useragent environment parameter defined'
	exit 1
fi

if [ ! -z $USERAGENT ];
then
	echo "User-Agent: $USERAGENT"
fi

if [ ! -z "$HEADER" ];
then
	echo "Header: $HEADER"
fi


if [ -z $MAXREQUESTS ];
then
	echo 'No $MAXREQUESTS environment parameter defined'
	exit 1
fi

if [ ! -z $MAXREQUESTS ];
then
	echo "Maximum Requests per second: $MAXREQUESTS"
fi

echo "-- Dir = $DIR" > $DIR/gospider-$DOMAIN-$DATE.txt
echo "-- Domain = $DOMAIN" >> $DIR/gospider-$DOMAIN-$DATE.txt
echo "-- Date = $DATE" >> $DIR/gospider-$DOMAIN-$DATE.txt

if [ -f $DIR/httpx-$DOMAIN-$DATE.txt ];
then
	echo "$DIR/httpx-$DOMAIN-$DATE already exists, omitting."
else	
	if [ ! -z $USERAGENT ]; 
	then
		echo "grep -v \"^--\" $DIR/$FILE | httpx -H \"User-Agent: $USERAGENT\" -rl $MAXREQUESTS -status-code -title -tech-detect -o $DIR/httpx-$DOMAIN-$DATE.txt"
		grep -v "^--" $DIR/$FILE | httpx -H "User-Agent: $USERAGENT" -rl $MAXREQUESTS -status-code -title -tech-detect -o $DIR/httpx-$DOMAIN-$DATE.txt
	fi

	if [ ! -z "$HEADER" ];
	then
		echo "grep -v \"^--\" $DIR/$FILE | httpx -H \"$HEADER\" -rl $MAXREQUESTS -status-code -title -tech-detect -o $DIR/httpx-$DOMAIN-$DATE.txt"
		grep -v "^--" $DIR/$FILE | httpx -H "$HEADER" -rl $MAXREQUESTS -status-code -title -tech-detect -o $DIR/httpx-$DOMAIN-$DATE.txt
	fi
fi

if [ -f $DIR/httpx-live-$DOMAIN-$DATE.txt ];
then
	echo "$DIR/httpx-live-$DOMAIN-$DATE already exists, omitting."
else	
	echo "grep -v \"^--\" $DIR/httpx-$DOMAIN-$DATE.txt | grep 200 | awk -e '{print $1}' > $DIR/httpx-live-$DOMAIN-$DATE.txt"
	grep -v "^--" $DIR/httpx-$DOMAIN-$DATE.txt | grep 200 | awk -e '{print $1}' > $DIR/httpx-live-$DOMAIN-$DATE.txt
fi

if [ -d $DIR/gospider-$DOMAIN-$DATE ];
then
	echo "$DIR/gospider-$DOMAIN-$DATE already exists, omitting."
else	
	if [ ! -z $USERAGENT ]; 
	then
		echo "gospider --user-agent $USERAGENT -k 1 -c 1 -S $DIR/httpx-live-$DOMAIN-$DATE.txt -o $DIR/gospider-$DOMAIN-$DATE -d 1"
		gospider --user-agent $USERAGENT -k 1 -c 1 -S $DIR/httpx-live-$DOMAIN-$DATE.txt -o $DIR/gospider-$DOMAIN-$DATE -d 1
	fi

	if [ ! -z "$HEADER" ];
	then
		echo "gospider -H \"$HEADER\" -k 1 -c 1 -S $DIR/httpx-live-$DOMAIN-$DATE.txt -o $DIR/gospider-$DOMAIN-$DATE -d 1"
		gospider -H "$HEADER" -k 1 -c 1 -S $DIR/httpx-live-$DOMAIN-$DATE.txt -o $DIR/gospider-$DOMAIN-$DATE -d 1
	fi
fi

#gospider --user-agent $USERAGENT -k 1 -c 1 -S $DIR/httpx-live-$DOMAIN-$DATE.txt -o $DIR/gospider-$DOMAIN-$DATE -d 1

