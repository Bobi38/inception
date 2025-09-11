#!/bin/bash

# Attendre que MariaDB soit prêt
echo "⏳ Attente de MariaDB..."
until nc -z mariadb-toto 3306; do
    echo "MariaDB pas encore prêt, attente..."
    sleep 3
done
echo "✅ MariaDB détecté !"

# Attendre un peu plus pour être sûr que MariaDB est initialisé
sleep 10

# Vérifier si WordPress est déjà installé
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "📦 Téléchargement de WP-CLI..."
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar

    # Télécharger WordPress seulement si pas déjà présent
    if [ ! -f /var/www/html/wp-load.php ]; then
        echo "⬇️ Téléchargement de WordPress..."
        ./wp-cli.phar core download --locale=en_GB --allow-root
    fi

    echo "⚙️ Configuration du fichier wp-config.php..."
    ./wp-cli.phar config create --allow-root \
        --dbname="$SQL_DATABASE" \
        --dbuser="$SQL_USER" \
        --dbpass="$SQL_PASSWORD" \
        --dbhost=mariadb-toto

    echo "🚀 Installation de WordPress..."
    ./wp-cli.phar core install --allow-root \
        --url="https://$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASS" \
        --admin_email="$WP_ADMIN_EMAIL"

    echo "👤 Création d'un utilisateur..."
    ./wp-cli.phar user create "$WP_USER" "$WP_EMAIL" \
        --user_pass="$WP_PASS" \
        --allow-root

    chown -R www-data:www-data /var/www/html/wp-content/
else
    echo "✅ WordPress déjà configuré !"
fi

# Démarrer PHP-FPM ou Apache
echo "🎯 Démarrage du serveur web..."
exec "$@"