#!/bin/bash

# load environment variables
source /srv/gitlab/env

# Initialize MySQL
echo "CREATE USER 'gitlab'@'%' IDENTIFIED BY '$MySQLPassword';" | \
  mysql -h $MySQLServerIP --user=root --password=$MySQLPasswordForRoot
echo "CREATE DATABASE IF NOT EXISTS gitlabhq_production DEFAULT CHARACTER SET \
  'utf8' COLLATE 'utf8_unicode_ci';" | mysql -h $MySQLServerIP --user=root --password=$MySQLPasswordForRoot
echo "GRANT SELECT, LOCK TABLES, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, \
  ALTER ON gitlabhq_production.* TO 'gitlab'@'%';" | mysql \
    -h $MySQLServerIP --user=root --password=$MySQLPasswordForRoot

# Initialize gitlab
cd /home/git/gitlab
su git -c "bundle exec rake gitlab:setup force=yes RAILS_ENV=production"

# fix timeout - https://github.com/gitlabhq/gitlabhq/issues/694 
sed -i 's/^timeout .*/timeout 300/' /home/git/gitlab/config/unicorn.rb


# disable firstrun script
chmod -x /srv/gitlab/scripts/firstrun.sh
