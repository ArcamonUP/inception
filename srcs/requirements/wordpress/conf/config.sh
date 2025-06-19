#!/bin/bash

until mysql -h "$DB_NAME" -u "$DB_USER" -p "$DB_PASSWORD" -e "SELECT 1;" > /dev/null > 2>&1; do
    sleep 1
done

mkdir -p /var/www/wordpress
cd /var/www/wordpress
rm -rf *

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

wp core download --allow-root

wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --dbhost=mariadb --allow-root

sleep 5

for i in {1..3}; do
    if wp core install --url=https://$DOMAIN_NAME \
    --title="$WP_TITLE" \
    --admin_user=$WP_ADMIN_USR \
    --admin_password=$WP_ADMIN_PWD \
    --admin_email=$WP_ADMIN_EMAIL \
    --skip-email --allow-root; then
        break
    else
        echo "Tentative $i échouée, nouvelle tentative dans 10 secondes..."
        sleep 10
    fi
done

wp user create $WP_USER $WP_EMAIL --role=author --user_pass=$WP_PWD --allow-root

wp theme install neve --version=2.8.2 --activate --allow-root

wp plugin install classic-editor --activate --allow-root
wp plugin update --all --allow-root

chown -R www-data:www-data /var/www/wordpress
chmod -R 755 /var/www/wordpress
chmod -R 644 /var/www/wordpress/wp-content
find /var/www/wordpress -type d -exec chmod 755 {} \;
find /var/www/wordpress -type f -exec chmod 644 {} \;

sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf
sed -i 's/user = www-data/user = www-data/g' /etc/php/7.3/fpm/pool.d/www.conf
sed -i 's/group = www-data/group = www-data/g' /etc/php/7.3/fpm/pool.d/www.conf
mkdir -p /run/php

exec /usr/sbin/php-fpm7.3 -F