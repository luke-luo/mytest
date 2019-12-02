FROM alpine:3.10

#nslookup app | grep Address | awk -F: '{print $2}' | awk -F' ' '{print $1}'

USER root

COPY index.html /usr/share/nginx/html
COPY get_all_ip.sh /tmp/
COPY loop.sh /tmp/

RUN chmod 755 /tmp/get_all_ip.sh
RUN chmod 755 /tmp/loop.sh

RUN apk update
#RUN apk add openrc
RUN apk add nginx
RUN adduser -D -g 'www' www

#VOLUME /www

RUN mkdir -p /www
RUN chown -R www:www /var/lib/nginx
RUN chown -R www:www /www
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
COPY index.html /www/
COPY nginx.conf /etc/nginx/nginx.conf
COPY host_ips.txt /www/
COPY tag.txt /www/
COPY tag2.txt /www/

EXPOSE 80

#RUN rc-service nginx stop

#RUN wget https://github.com/nginx/nginx/archive/release-1.17.3.tar.gz 
#RUN tar xzfv release-1.17.3.tar.gz
#RUN cd nginx-release-1.17.3

#CMD ["sh", "-c", "/tmp/get_all_ip.sh"]
#ENTRYPOINT ["sh", "/tmp/get_all_ip.sh"]
#CMD service nginx restart
#CMD rc-service nginx start

#CMD ["nginx", "-g", "daemon off;"]
WORKDIR /tmp
CMD ["/tmp/loop.sh"]
#CMD /tmp/loop.sh

