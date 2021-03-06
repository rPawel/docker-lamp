#!/bin/bash
PERSISTENT_CONFIG_FOLDER="/root/.persistent-config"
PERSISTENT_IGNORED_CONFIG_FOLDER=$PERSISTENT_CONFIG_FOLDER/.ignore
VOLATILE_CONFIG_FOLDER="/"

if [ ! -d /var/www/app ]; then
    mkdir -p /var/www/app/public
    chown -R user:www-data /var/www/app
fi
if [ ! -d /var/www/cron ]; then
    mkdir -p /var/www/cron
    chown -R user:www-data /var/www/cron
    chmod 750 /var/www/cron
fi
rm -rf /home; ln -s /var/www/app /home
mkdir -p /var/log/php5 /var/log/apache2
chmod 775 /var/log/php5 /var/log/apache2
find /var/log/php5 /var/log/apache2 -type f -exec chmod 644 {} \;
chown -R user:www-data /var/log/php5 /var/log/apache2

cp -ar ${PERSISTENT_CONFIG_FOLDER}/* ${VOLATILE_CONFIG_FOLDER}

# start container
exec /usr/bin/supervisord -c /etc/supervisord.conf
