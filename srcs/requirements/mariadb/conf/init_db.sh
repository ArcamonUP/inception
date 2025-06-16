#!/bin/bash

pkill -f mysqld || true
rm -f /var/lib/mysql/aria_log_control
rm -f /var/lib/mysql/ibdata1.lock
rm -f /var/run/mysqld/mysqld.pid

chown -R mysql:mysql /var/lib/mysql
chown -R mysql:mysql /var/run/mysqld
chmod -R 755 /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

mysqld --user=mysql --bootstrap --verbose=0 --skip-networking=0 <<EOF
USE mysql;
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '12345';
FLUSH PRIVILEGES;
EOF

echo "Base de données initialisée avec succès"

exec mysqld --user=mysql --datadir=/var/lib/mysql