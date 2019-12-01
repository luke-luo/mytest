#!/bin/sh


rm -f /www/my_ip.txt
MYIP=$(ip route get 1 | awk '{print $NF;exit}')
echo $MYIP > /www/my_ip.txt

rm -f /mydata/all_ip.txt
nslookup app | grep Address | awk -F: '{print $2}' | awk -F' ' '{print $1}' > /mydata/all_ip.txt
ln -s /mydata/all_ip.txt /www/all_ip.txt
#nginx -g 'daemon off'
#nginx -s start

