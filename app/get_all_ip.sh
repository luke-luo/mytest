#!/bin/sh

rm -f /mydata/all_ip.txt
nslookup app | grep Address | awk -F: '{print $2}' | awk -F' ' '{print $1}' > /mydata/all_ip.txt
ln -s /mydata/all_ip.txt /www/all_ip.txt
#nginx -g 'daemon off'
#nginx -s start

