#!/bin/bash

sleep 10

mkdir -p /var/www/wordpress

cd /var/www/wordpress

rm -rf *

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

wp core download --allow-root

mv wp-config-sample.php wp-config.php
mv /wp-config.php /var/www/wordpress/wp-config.php

sed -i -r "s/db1/$db_name/" wp-config.php
sed -i -r "s/db1_user/$db_user/" wp-config.php
sed -i -r "s/db1_pwd/$db_pwd/" wp-config.php

wp core install --url=$DOMAIN_NAME \
                --title=$WP_TITLE \
                --admin_user=$WP_ADMIN \
                --admin_password=$WP_ADMIN_PASSWORD \
                --admin_email=$WP_ADMIN_EMAIL \
                --skip-email --allow-root

wp user create $WP_USER $WP_EMAIL --role=author --user_pass=$WP_PASSWORD --allow-root

wp theme install astra --activate --allow-root

wp plugin install redis-cache --activate --allow-root
wp plugin update --all --allow-root

sed -i 's/listen = \/run\/php\/php7.3-fpm.sock/listen = 9000/g' /etc/php/7.3/fpm/pool.d/www.conf

mkdir /run/php

wp redis enable --allow-root

/usr/sbin/php-fpm7.3 -F