#!/usr/bin/env bash

debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'

add-apt-repository ppa:ondrej/php
apt-get update && sudo apt-get upgrade

# Install Apache 2.4, its documentation, and a collection of utilities
apt-get install -y apache2 apache2-doc apache2-utils

# Apache conf
a2dismod mpm_event
a2enmod mpm_prefork
a2enmod rewrite

# Install php
apt-get install -y php5.6-mbstring php5.6-mcrypt php5.6-mysql php5.6-xml php5.6-cli libapache2-mod-php5.6

# Instal mysql
apt-get install -y mysql-server mysql-client

# Set up NFS
apt-get install nfs-kernel-server nfs-common portmap

if ! [ -L /var/www ]; then
  rm -rf /var/www
  ln -fs /vagrant /var/www
fi

# Create virtualhosts
# Modify this section so it copies each projects .conf file to /etc/apache2/sites-available/
# For example
# cp /vagrant/install/virtualhosts/my_project_name.conf /etc/apache2/sites-available/


# Enable sites
# For example
# a2ensite my_project_name.conf

# Change default virtual host to avoid warning for not found document
sed -i "s/html/install/g" /etc/apache2/sites-available/000-default.conf

# Change php configuration
sed -i "s/display_startup_errors = Off/display_startup_errors = On/g" /etc/php/5.6/apache2/php.ini
sed -i "s/display_errors = Off/display_errors = On/g" /etc/php/5.6/apache2/php.ini

# Avoid warning about server name
echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Restart apache
service apache2 restart

# Import databases

# Modify this array so it metches the name of the sql dump files and the database names
# For example
# dbs=( my_project_name my_project_name_2 ... )

LOCAL_DB_USER="root"
LOCAL_DB_PASS="password"

echo "Creating databases..."
for i in "${dbs[@]}"
do
  mysql -u$LOCAL_DB_USER -p$LOCAL_DB_PASS  -e "drop database if exists $i"
  mysql -u$LOCAL_DB_USER -p$LOCAL_DB_PASS  -e "create database $i default charset utf8"
  mysql -u$LOCAL_DB_USER -p$LOCAL_DB_PASS  $i < /vagrant/install/databases/$i.sql
done
