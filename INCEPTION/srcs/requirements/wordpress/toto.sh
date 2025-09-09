#!/bin/bash

# if [ -n "$SQL_PASSWORD_FILE" ]; then
#     export SQL_PASSWORD=$(cat "$SQL_PASSWORD_FILE")
# fi


echo  "wordpresse $SQL_PASSWORD"
cd /var/www/html

echo "📦 Downloading wp-cli..."
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar

# # ⏳ Attendre que la base MariaDB soit prête
# echo "⏳ Waiting for MariaDB to be ready..."
# until mysqladmin ping -h"mariadb" --silent; do
#     sleep 3
# done
# echo "✅ MariaDB is ready!"

# Télécharger WordPress si absent
# if [ ! -f wp-load.php ]; then
#     echo "⬇️ Downloading WordPress..."
    ./wp-cli.phar core download --allow-root
# fi

# Créer le wp-config.php si absent
if [ ! -f wp-config.php ]; then
    echo "⚙️ Creating wp-config.php..."
    ./wp-cli.phar config create --allow-root \
        --dbname="$SQL_DATABASE" \
        --dbuser="$SQL_USER" \
        --dbpass="$SQL_PASSWORD" \
        --dbhost=mariadb:3306 --path='/var/www/wordpress'
fi

# Installer WordPress
if ! ./wp-cli.phar core is-installed --allow-root; then
    echo "🌐 Installing WordPress..."
    ./wp-cli.phar core install --allow-root \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASS" \
        --admin_email="$WP_ADMIN_EMAIL"
fi

# Propriétés des fichiers
chown -R www-data:www-data /var/www/html

exec "$@"