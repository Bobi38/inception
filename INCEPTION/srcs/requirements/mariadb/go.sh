#!/bin/bash
set -e

export SQL_ROOT_PASSWORD=$(cat /run/secrets/mysql_root_password)

chgrp -R mysql /var/lib/mysql
chmod -R g+rwx /var/lib/mysql

mysql_install_db

service mariadb start

mariadbd --bootstrap --skip-networking=0 <<-EOSQL
CREATE DATABASE IF NOT EXISTS $SQL_DATABASE;
CREATE USER IF NOT EXISTS $SQL_USER@'localhost' IDENTIFIED BY "$($SQL_PASSWORD)";
GRANT ALL PRIVILEGES ON $SQL_DATABASE.* TO $SQL_USER@'%' IDENTIFIED BY "$($SQL_PASSWORD)";
SET PASSWORD FOR 'root'@'localhost' = PASSWORD("$($SQL_ROOT_PASSWORD)");
FLUSH PRIVILEGES;
EOSQL

    echo "[INFO] Initialisation terminée."
    service mariadb stop
fi

echo "[INFO] Démarrage normal de MariaDB..."
exec "$@"


