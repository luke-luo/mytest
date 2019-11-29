nslookup app | grep Address | awk -F: '{print $2}' | awk -F' ' '{print $1}' > /www/all_ip.txt
#nginx -g 'daemon off'
#nginx -s start

