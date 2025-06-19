#!/bin/bash
set -euo pipefail

mkdir -p /var/www/wordpress
cd /var/www/wordpress
rm -rf *

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

wp core download --allow-root

wp config create --dbname="$DB_NAME" --dbuser="$DB_USER" \
                 --dbpass="$DB_PASSWORD" --dbhost=mariadb --allow-root

for i in {1..20}; do
    if wp db check --allow-root > /dev/null 2>&1; then
        break
    fi
    sleep 1
done

wp core install --url="https://$DOMAIN_NAME" \
                    --title="$WP_TITLE" \
                    --admin_user="$WP_ADMIN_USR" \
                    --admin_password="$WP_ADMIN_PWD" \
                    --admin_email="$WP_ADMIN_EMAIL" \
                    --skip-email --allow-root

wp user create "$WP_USER" "$WP_EMAIL" --role=author --user_pass="$WP_PWD" --allow-root

wp theme install astra --activate --allow-root
wp plugin install classic-editor --activate --allow-root
wp plugin update --all --allow-root

chown -R www-data:www-data /var/www/wordpress
find /var/www/wordpress -type d -exec chmod 755 {} \;
find /var/www/wordpress -type f -exec chmod 644 {} \;

sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' \
       /etc/php/7.4/fpm/pool.d/www.conf
mkdir -p /run/php

exec /usr/sbin/php-fpm7.4 -F
