#!/bin/bash


if [ -f env ]; then
     source ./env
else
     cp env.sample env
     echo "edit env and run this script again"
     exit 1
fi

cd config_sample
for f in *
do
    if [ -f ../config/$f ]; then
        echo "skip $f"
    else
        sed -e "s/SERVER_NAME/$ServerName/" \
            -e "s/GITLAB_PORT/$GitlabPort/" \
            -e "s/MYSQL_ROOT_PASSWORD/$MySQLPasswordForRoot/" \
            -e "s/MYSQL_SERVER_IP/$MySQLServerIP/" \
            -e "s/MYSQL_SERVER_PORT/$MySQLServerPort/" \
            -e "s/LSYNCD_TARGET_HOST/$LsyncdTargetHost/" \
            -e "s/LSYNCD_USER/$LsyncdUser/" \
            -e "s|LSYNCD_IDENTITY_FILE|$LsyncdIdentityFile|" \
            $f > ../config/$f
    fi
done



