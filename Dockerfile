FROM ubuntu:latest

RUN apt-get update && apt-get install -y curl nginx inotify-tools
COPY entry.sh /entry.sh
RUN chmod 777 /entry.sh

ENV WATCH_FILES "/etc/nginx/sites-enabled/*.conf /etc/certs"

RUN rm -Rvf /etc/nginx
RUN mkdir /etc/nginx

COPY ./config /etc/nginx
COPY ./www /var/www
COPY ./log /var/log
COPY ./offline /var/offline

RUN mkdir -p /etc/nginx/certs
RUN mkdir -p /var/www/certbot

ENTRYPOINT [ "/entry.sh" ]
