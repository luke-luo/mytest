FROM alpine:3.10

USER root

COPY index.html /usr/share/nginx/html
COPY get_all_ip.sh /tmp/
#COPY loop.sh /tmp/

RUN chmod 755 /tmp/get_all_ip.sh
#RUN chmod 755 /tmp/loop.sh
RUN apk update
#RUN apk add openrc
RUN apk add nginx
RUN adduser -D -g 'www' www

RUN mkdir -p /www
RUN chown -R www:www /var/lib/nginx
RUN chown -R www:www /www
RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.orig
COPY index.html /www/
COPY nginx.conf /etc/nginx/nginx.conf
COPY host_ips.txt /www/host_ips.txt
COPY tag.txt /www/tag.txt
COPY tag2.txt /www/tag2.txt
COPY elb_dns_name.txt /www/elb_dns_name.txt

EXPOSE 80

WORKDIR /tmp
RUN /tmp/get_all_ip.sh 
CMD ["nginx", "-g", "daemon off;"]

