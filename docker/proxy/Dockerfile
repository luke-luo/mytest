FROM nginx:alpine

RUN rm /etc/nginx/conf.d/*

#nslookup app | grep Address | awk -F: '{print $2}' | awk -F' ' '{print $1}'

COPY proxy.conf /etc/nginx/conf.d/

EXPOSE 8080
