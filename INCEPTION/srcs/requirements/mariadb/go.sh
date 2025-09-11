#!/bin/bash
set -e

export SQL_ROOT_PASSWORD=$(cat /run/secrets/mysql_root_password)

echo $SQL_PASSWORD

echo "[INFO] SQL_ROOT_PASSWORD chargé."

mkdir -p /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld

if [ ! -d /var/lib/mysql/mysql ]; then
    echo "[INFO] Initialisation de MariaDB..."
    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql > /dev/null

    echo "[INFO] Configuration de la base initiale..."
    mysqld --user=mysql --bootstrap <<-EOSQL
        CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
        CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}' WITH GRANT OPTION;
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
        ALTER USER 'root'@'%' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';

        FLUSH PRIVILEGES;
EOSQL

    echo "[INFO] Initialisation terminée."
else
    echo "[INFO] Base de données déjà initialisée."
fi

# Lancer le serveur MariaDB
echo "[INFO] Démarrage normal de MariaDB..."
exec "$@"


