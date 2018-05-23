FROM ubuntu:16.04

RUN apt-get update \
    && apt-get install -y nginx \
    && echo "daemon off;" >> /etc/nginx/nginx.conf

ADD index.html /var/www/html/

EXPOSE 80

CMD ["nginx"]
