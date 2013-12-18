#!/bin/bash


#docker run -t -i -p 8080:80 -p 22:22 -v `pwd`/../docker-lsyncd/home/data:/srv/gitlab:rw essa/gitlab
#docker run -t -i -p 8080:80 -p 22:22 -v `pwd`:/srv/gitlab:rw essa/gitlab /srv/gitlab/start.sh
docker run -d -p 8080:80 -p 22:22 -v `pwd`:/srv/gitlab:rw essa/gitlab /srv/gitlab/start.sh

