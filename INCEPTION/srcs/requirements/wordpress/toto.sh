#!/bin/bash

cd /var/www/html

if [ -f "/var/www/html/wp-config.php" ]; then
    echo Wordpress already configurated
else
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar

    ./wp-cli.phar core download --locale=en_GB --allow-root
    ./wp-cli.phar config create --allow-root --dbname="$SQL_DATABASE" --dbuser="$SQL_USER" --dbpass="$($SQL_PASSWORD)" \
                 --dbhost=mariadb
    ./wp-cli.phar core install --allow-root --url="https://$WP_URL" --title="$WP_TITLE" --admin_user="$WP_ADMIN_USER" \
                --admin_password="$($WP_ADMIN_PASS)" --admin_email="$WP_ADMIN_EMAIL"
    ./wp-cli.phar user create --allow-root "$WP_USER" "$WP_EMAIL" --user_pass="$($WP_PASS)" --path="$WP_PATH" --allow-root

    chown -R www-data:www-data /var/www/html/wp-content/
fi

exec "$@"