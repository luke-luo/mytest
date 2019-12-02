#!/bin/sh


rm -f /www/my_ip.txt
MYIP=$(ip route get 1 | awk '{print $NF;exit}')
echo $MYIP > /www/my_ip.txt

HOSTIP=$(cat /www/host_ips.txt)
echo "HOSTIP:" $HOSTIP

TAGNAME=$(cat /www/tag.txt)
echo "TAGNAME:" $TAGNAME
TAGNAME2=$(cat /www/tag2.txt)
echo "TAGNAME2:" $TAGNAME2

mkdir -p /mydata/ip_list

rm -f /mydata/ip_list/$TAGNAME.txt
echo "HOSTIP:" $HOSTIP > /mydata/ip_list/$TAGNAME.txt
echo "Tag name: $TAGNAME" >> /mydata/ip_list/$TAGNAME.txt
echo "All Nginx IPs:" >> /mydata/ip_list/$TAGNAME.txt
nslookup app | grep Address | awk -F: '{print $2}' | awk -F' ' '{print $1}' >> /mydata/ip_list/$TAGNAME.txt


ln -s -f /mydata/ip_list/$TAGNAME.txt /www/all_ip.txt
ln -s -f /mydata/ip_list/$TAGNAME2.txt /www/all_ip2.txt

