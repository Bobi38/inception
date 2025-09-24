#!/bin/bash

export SQL_PASSWORD=$(cat /run/secrets/wordpress_db_password)
export WP_ADMIN_PASS=$(cat /run/secrets/wordpress_admin_password)

echo "⏳ Attente de MariaDB..."
until nc -z mariadb-toto 3306; do
    echo "MariaDB pas encore prêt, attente..."
    sleep 3
done
echo "MariaDB détecté !"

# until mysql -h mariadb-toto -u "$SQL_USER" -p"$SQL_PASSWORD" "$SQL_DATABASE" -e "SELECT 1;" > /dev/null 2>&1; do
#     echo "⏳ En attente que l'utilisateur soit reconnu par MariaDB..."
#     sleep 2
# done

echo "✅ Connexion MySQL avec $SQL_USER réussie !"
if [ ! -f /var/www/html/wp-cli.phar ]; then
    echo "📦 Téléchargement de WP-CLI..."
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
else
    echo "✅ WordPress déjà installé !"
fi
    chmod +x wp-cli.phar
    php wp-cli.phar --info
    mv wp-cli.phar /usr/local/bin/wp

wp cli update 


wp core download --locale=en_GB --allow-root

if [ ! -f /var/www/html/wp-config.php ]; then
echo "CONGIG wp-config.php..."
wp config create --allow-root --dbname="$SQL_DATABASE" --dbuser="$SQL_USER" --dbpass="$SQL_PASSWORD" --dbhost=mariadb-toto
else
    echo "----- wp-config existe deja --------"
fi

if ! wp core is-installed --allow-root; then
echo "INSTALLATION de WordPress..."
wp core install --allow-root --url="https://$WP_URL" --title="$WP_TITLE" --admin_user="$WP_ADMIN_USER" --admin_password="$WP_ADMIN_PASS" --admin_email="$WP_ADMIN_EMAIL"
else 
    echo "----- wp core install a deja ete lancé -----"
fi

if ! wp user list --field=user_login --allow-root | grep -q "^$WP_USER$"; then
echo "👤CREER USER..."
wp user create --allow-root "$WP_USER" "$WP_EMAIL" --user_pass="$WP_PASS"
else
    echo "------- le user a deja ete crée ------"
fi

chown -R www-data:www-data /var/www/html/wp-content/


echo "🎯 Démarrage du serveur web..."
exec "$@"