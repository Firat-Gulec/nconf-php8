#!/bin/sh
set -e

cd /var/www/html

# First start: create ./config from ./config.orig and point it at the DB container
if [ ! -f config/nconf.php ]; then
    mkdir -p config
    cp -a config.orig/. config/
    sed -i "s#define('NCONFDIR',.*#define('NCONFDIR',     '/var/www/html');#" config/nconf.php
    sed -i "s#define('NAGIOS_BIN',.*#define('NAGIOS_BIN',   '/usr/sbin/nagios4');#" config/nconf.php
    sed -i "s#define('DBHOST'.*#define('DBHOST', '${DBHOST:-db}');#" config/mysql.php
    sed -i "s#define('DBNAME'.*#define('DBNAME', '${DBNAME:-NConf}');#" config/mysql.php
    sed -i "s#define('DBUSER'.*#define('DBUSER', '${DBUSER:-nconf}');#" config/mysql.php
    sed -i "s#define('DBPASS'.*#define('DBPASS', '${DBPASS:-link2db}');#" config/mysql.php
fi

chown -R www-data:www-data config output static_cfg temp

exec "$@"
