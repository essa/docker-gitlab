#!/bin/bash

if [ $# -ne 1 ]; then
  echo "usage: start_lsyncd.sh MOUNT_POINT"
  exit 1
fi

DIR=`(cd \`dirname $0\`; pwd -P)`
source $DIR/../env

mkdir -p $DIR/ssh
cp $DIR/../config/ssh_config_for_lsyncd $DIR/ssh/config
cp $LsyncdIdentityFile $DIR/ssh
D=$(docker run -d -p 22 -v $DIR/ssh:/root/.ssh:rw -v $1:/mnt/data lsyncd)
echo $D
sleep 3
docker logs $D


