#!/bin/bash

set -eo pipefail

rm -f /var/lib/mysql/aria_log_control /var/lib/mysql/ibdata1.lock
rm -f /var/run/mysqld/mysqld.pid || true

chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
chmod -R 755 /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadbd --initialize-insecure --user=mysql --datadir=/var/lib/mysql
fi

mariadbd --user=mysql --bootstrap <<EOF
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS $DB_NAME;
CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '12345';
FLUSH PRIVILEGES;
EOF

echo "Base de données initialisée avec succès"

exec mariadbd --user=mysql --datadir=/var/lib/mysql
