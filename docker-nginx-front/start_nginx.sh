#!/bin/bash

DIR=`(cd \`dirname $0\`; pwd -P)`

cp $DIR/../config/nginx_front $DIR/sites-enabled
docker run -d -p 0.0.0.0:80:80 -v $DIR/sites-enabled:/etc/nginx/sites-enabled docker-nginx

