#!/bin/bash
export TIMEZONE="$1"
export TMPENV=/home/etude/tmpenv
export TZ=$TIMEZONE
(cat /etc/environment | grep -v ^TZ=  | grep -v ^$ && echo TZ=\"$TIMEZONE\") > $TMPENV
cp $TMPENV /etc/environment
rm -f $TMPENV
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
echo "New system date : $(date)"
exit
