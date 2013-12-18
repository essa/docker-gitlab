# DOCKER-VERSION 0.6.4

FROM ubuntu:12.04

RUN echo deb http://archive.ubuntu.com/ubuntu precise main universe multiverse > /etc/apt/sources.list
RUN apt-get install -y python-software-properties
RUN add-apt-repository ppa:nginx/development
RUN apt-get update
RUN apt-get install -y nginx
RUN rm /etc/nginx/sites-enabled/default
RUN sed -i 's/# server_names_hash_bucket_size 64;/server_names_hash_bucket_size 64;/g' /etc/nginx/nginx.conf
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN mkdir /etc/nginx/extras

VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/extras"]

EXPOSE 80 443
CMD ["nginx"]
