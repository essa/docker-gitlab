#!/bin/bash


D=$(docker run -d -p 8080:80 -p 22:22 -v `pwd`:/srv/gitlab:rw gitlab)
echo $D
sleep 5
docker logs $D


