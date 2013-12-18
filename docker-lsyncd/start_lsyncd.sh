#!/bin/bash

if [ $# -ne 1 ]; then
  echo "usage: start_lsyncd.sh MOUNT_POINT"
  exit 1
fi

mkdir -p home
#docker run -d -p 10022:22 -v `pwd`/home:/home/lsyncd:rw essa/lsyncd lsyncd -nodaemon -rsyncssh /home/lsyncd/data sakuravps2 replica/lsyncd
docker run -d -p 10022:22 -v `pwd`/home:/home/lsyncd:rw -v $1:/home/data essa/lsyncd
