#!/bin/bash
set -e

# # Attendre que MariaDB soit prêt
# echo "⏳ Attente de MariaDB..."
# until nc -z mariadb-toto 3306; do
#     echo "MariaDB pas encore prêt, attente..."
#     sleep 3
# done
# echo "✅ MariaDB détecté !"

# sleep 5  # Pour s'assurer que la DB est bien initialisée

sleep 10

# Installer WP-CLI si nécessaire
if ! command -v wp >/dev/null 2>&1; then
    echo "📦 Téléchargement de WP-CLI..."
    curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Télécharger WordPress si nécessaire
if [ ! -f /var/www/html/wp-load.php ]; then
    echo "⬇️ Téléchargement de WordPress..."
    wp core download --locale=en_GB --allow-root
fi

# Créer le fichier de config si nécessaire
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "⚙️ Création du fichier wp-config.php..."
    wp config create --allow-root \
        --dbname="$SQL_DATABASE" \
        --dbuser="$SQL_USER" \
        --dbpass="$SQL_PASSWORD" \
        --dbhost="mariadb-toto"
fi

# Installer WordPress si pas déjà installé
if ! wp core is-installed --allow-root; then
    echo "📦 Installation de WordPress..."
    wp core install --allow-root \
        --url="https://$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASS" \
        --admin_email="$WP_ADMIN_EMAIL"

    echo "👤 Création de l'utilisateur normal..."
    wp user create "$WP_USER" "$WP_EMAIL" \
        --user_pass="$WP_PASS" \
        --allow-root
else
    echo "✅ WordPress déjà installé."
fi

# Afficher la config WP
wp config list --allow-root

# Fixer les permissions
chown -R www-data:www-data /var/www/html/wp-content/

# Lancer PHP-FPM ou Apache
echo "🎯 Démarrage du serveur web..."
exec "$@"
