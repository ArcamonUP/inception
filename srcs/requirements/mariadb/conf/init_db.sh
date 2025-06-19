#!/bin/bash
set -e

DATA_DIR=/var/lib/mysql
FLAG=$DATA_DIR/.initialized

chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

if [ ! -d "$DATA_DIR/mysql" ]; then
    mariadbd --initialize-insecure --user=mysql --datadir=$DATA_DIR
fi

if [ ! -f "$FLAG" ]; then
    mariadbd --user=mysql --bootstrap <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
ALTER USER IF EXISTS 'root'@'localhost' IDENTIFIED BY '12345';
FLUSH PRIVILEGES;
EOF
    touch "$FLAG"
fi

exec mariadbd --user=mysql --datadir=$DATA_DIR
