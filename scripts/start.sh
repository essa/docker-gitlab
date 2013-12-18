#!/bin/bash

source /srv/gitlab/env

# upstart workaround
dpkg-divert --local --rename --add /sbin/initctl
ln -s /bin/true /sbin/initctl

# Copy over config files
cp /srv/gitlab/config/nginx /etc/nginx/sites-available/gitlab
ln -s /etc/nginx/sites-available/gitlab /etc/nginx/sites-enabled/gitlab
cp /srv/gitlab/config/gitlab.yml /home/git/gitlab/config/gitlab.yml

cp /srv/gitlab/config/database.yml /home/git/gitlab/config/database.yml
chown git:git /home/git/gitlab/config/database.yml && chmod o-rwx /home/git/gitlab/config/database.yml

# chmod and chown for mounted directories
chown -R git /srv/gitlab/data/tmp/ && chmod -R u+rwX  /srv/gitlab/data/tmp/
chown -R git:git /srv/gitlab/data/ssh && chmod -R 0700 /srv/gitlab/data/ssh && chmod 0700 /home/git/.ssh
chown -R git:git /srv/gitlab/data/gitlab-satellites
chown -R git:git /srv/gitlab/data/repositories && chmod -R ug+rwX,o-rwx /srv/gitlab/data/repositories && chmod -R ug-s /srv/gitlab/data/repositories/
find /srv/gitlab/data/repositories/ -type d -print0 | xargs -0 chmod g+s

# start redis
redis-server > /dev/null 2>&1 &
sleep 5

# Run the firstrun script
if [ -x /srv/gitlab/scripts/firstrun.sh ]; then
	echo "Initializing DB and configuration"
	/srv/gitlab/scripts/firstrun.sh
	echo "Initializing DB and configuration end"
else
	echo "found firstrun.sh donw, continue start up"
fi

# set password
echo "git:${Password}" |chpasswd

# remove PIDs created by GitLab init script
rm /home/git/gitlab/tmp/pids/*

# start gitlab
service gitlab start

# start nginx
service nginx start

# wait for gitlab start up
sleep 5

# start SSH to keep script in foreground
mkdir -p /var/run/sshd
/usr/sbin/sshd

