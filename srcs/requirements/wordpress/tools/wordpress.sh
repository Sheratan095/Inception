#!/bin/bash

set -e

until mysql -h mariadb -u"$DB_USER" -p"$DB_PASS" -e "SELECT 1;" &> /dev/null; do
  echo "Waiting for MariaDB..."
  sleep 2
done

cd /var/www/html

if [ ! -f wp-config.php ]; then
    wp core download --allow-root

    wp config create --allow-root --dbname="$DB_NAME" --dbuser="$DB_USER" --dbpass="$DB_PASS" --dbhost="$DB_HOST"

    wp core install  --allow-root --url="$URL" --title="$TITLE" --admin_user="$WP_ADMIN" --admin_password="$WP_ADMIN_PASSWORD" --admin_email="$WP_ADMIN_EMAIL"

    wp user create   --allow-root "$WP_USER" "$WP_USER_EMAIL" --user_pass="$WP_USER_PASS"

    #Bonus part

    wp config set WP_REDIS_HOST redis --add --allow-root

    wp config set WP_REDIS_PORT 6379 --add --allow-root

    wp config set WP_CACHE true --add --allow-root

    wp plugin install redis-cache --allow-root

    wp plugin activate redis-cache --allow-root

    wp plugin update --all --allow-root

    wp redis enable --allow-root

    wp cache flush --allow-root
fi

unset $DB_USER $DB_PASS $WP_ADMIN $WP_ADMIN_PASSWORD $WP_USER $WP_USER_PASS $FTP_USER $FTP_PASSWORD

mkdir -p /run/php

php-fpm7.4 -F
