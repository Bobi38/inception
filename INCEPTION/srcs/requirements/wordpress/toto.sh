#!/bin/bash
set -e

cd /var/www/html

if [ -f "wp-config.php" ]; then
    echo "✅ WordPress déjà configuré."
else
    echo "📦 Téléchargement de WP-CLI..."
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar

    echo "⬇️ Téléchargement de WordPress..."
    ./wp-cli.phar core download --locale=en_GB --allow-root

    echo "⚙️ Configuration du fichier wp-config.php..."
    ./wp-cli.phar config create --allow-root \
        --dbname="$SQL_DATABASE" \
        --dbuser="$SQL_USER" \
        --dbpass="$SQL_PASSWORD" \
        --dbhost=db

    echo "🌐 Installation de WordPress..."
    ./wp-cli.phar core install --allow-root \
        --url="https://$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASS" \
        --admin_email="$WP_ADMIN_EMAIL"

    echo "👤 Création de l’utilisateur supplémentaire..."
    ./wp-cli.phar user create "$WP_USER" "$WP_EMAIL" \
        --user_pass="$WP_PASS" \
        --allow-root

    chown -R www-data:www-data /var/www/html/wp-content/
fi

exec "$@"