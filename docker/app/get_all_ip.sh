#!/bin/sh

#sleep 5

HOSTIP=$(cat /www/host_ips.txt)
echo "HOSTIP:" $HOSTIP

TAGNAME=$(cat /www/tag.txt)
echo "TAGNAME:" $TAGNAME
TAGNAME2=$(cat /www/tag2.txt)
echo "TAGNAME2:" $TAGNAME2

rm -f /www/my_ip.txt
MYIP=$(ip route get 1 | awk '{print $NF;exit}')
echo $MYIP > /www/my_ip.txt

HTMLFILE=/www/index.html
rm -f /www/index.html
ln -s -f /mydata/ip_list/$TAGNAME.html $HTMLFILE

