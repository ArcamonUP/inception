#!/bin/bash

DATA_DIR=/var/lib/mysql
FLAG_FILE=$DATA_DIR/.initialized

chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

if [ ! -d "$DATA_DIR/mysql" ]; then
    mariadbd --initialize-insecure --user=mysql --datadir=$DATA_DIR
fi

if [ ! -f "$FLAG_FILE" ]; then
    mariadbd --user=mysql --bootstrap <<EOF
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '12345';
FLUSH PRIVILEGES;
EOF
    touch "$FLAG_FILE"
fi

exec mariadbd --user=mysql --datadir=$DATA_DIR
