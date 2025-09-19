#!/bin/bash

set -e

# Lire le mot de passe root depuis un secret Docker
export SQL_ROOT_PASSWORD=$(cat /run/secrets/mysql_root_password)

# Préparer les répertoires
mkdir -p /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld

# Initialisation de la base de données si vide
if [ ! -d /var/lib/mysql/mysql ]; then
    echo "[DEBUG] 📦 Initialisation de MariaDB..."
    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql > /dev/null

    echo "[DEBUG] 🚀 Démarrage temporaire de MariaDB..."
    mysqld_safe --nowatch --datadir=/var/lib/mysql &
    sleep 5

    echo "[DEBUG] 🛠️ Création base + utilisateur..."
    mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '$SQL_ROOT_PASSWORD';
CREATE DATABASE IF NOT EXISTS $SQL_DATABASE;
CREATE USER IF NOT EXISTS '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD';
GRANT ALL PRIVILEGES ON $SQL_DATABASE.* TO '$SQL_USER'@'%';
FLUSH PRIVILEGES;
EOF

    echo "[DEBUG] ✅ Initialisation terminée."
    mysqladmin -u root -p"$SQL_ROOT_PASSWORD" shutdown
else
    echo "[DEBUG] ✅ Base de données déjà initialisée."
fi

# Démarrer MariaDB en mode normal
echo "[DEBUG] 🚀 Lancement de MariaDB..."
exec "$@"