#!/bin/bash

# Set these parameters
DBServer=172.17.42.1
mysqlRoot=root
PassForGit=defaultpass

# === Do not modify anything in this section ===

# set defaultpass
echo "git:$PassForGit" | chpasswd

# Regenerate the SSH host key
/bin/rm /etc/ssh/ssh_host_*
dpkg-reconfigure openssh-server

# ==============================================

# === Delete this section if restoring data from previous build ===

# Initialize MySQL
mysqladmin -h $DBServer -u root --password=root password $mysqlRoot
echo "CREATE USER 'gitlab'@'%' IDENTIFIED BY '$password';" | \
  mysql -h $DBServer --user=root --password=$mysqlRoot
echo "CREATE DATABASE IF NOT EXISTS gitlabhq_production DEFAULT CHARACTER SET \
  'utf8' COLLATE 'utf8_unicode_ci';" | mysql -h $DBServer --user=root --password=$mysqlRoot
echo "GRANT SELECT, LOCK TABLES, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, \
  ALTER ON gitlabhq_production.* TO 'gitlab'@'%';" | mysql \
    -h $DBServer --user=root --password=$mysqlRoot

cd /home/git/gitlab
su git -c "bundle exec rake gitlab:setup force=yes RAILS_ENV=production"
sleep 5
su git -c "bundle exec rake db:seed_fu RAILS_ENV=production"

# fix timeout - https://github.com/gitlabhq/gitlabhq/issues/694 
sed -i 's/^timeout .*/timeout 300/' /home/git/gitlab/config/unicorn.rb

# ================================================================

# disable firstrun script
chmod -x /srv/gitlab/firstrun.sh
