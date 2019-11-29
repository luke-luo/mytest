FROM nginx:alpine

#nslookup app | grep Address | awk -F: '{print $2}' | awk -F' ' '{print $1}'

COPY index.html /usr/share/nginx/html
COPY get_all_ip.sh /tmp/

RUN chmod 755 /tmp/get_all_ip.sh

#CMD ["sh", "-c", "/tmp/get_all_ip.sh"]
#ENTRYPOINT ["sh", "/tmp/get_all_ip.sh"]


