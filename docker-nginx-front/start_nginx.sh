#!/bin/bash

docker run -d -p 0.0.0.0:80:80 -v /home/tnaka/docker-nginx/sites-enabled:/etc/nginx/sites-enabled docker-nginx

