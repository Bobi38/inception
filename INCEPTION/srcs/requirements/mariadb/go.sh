#!/bin/bash
set -e

export SQL_ROOT_PASSWORD=$(cat /run/secrets/mysql_root_password)

mkdir -p /run/mysqld
chown -R mysql:mysql /var/lib/mysql /run/mysqld

if [ ! -d /var/lib/mysql/mysql ]; then
  echo "Initialisation de MariaDB..."
  mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql > /dev/null
fi

echo "Démarrage MariaDB temporaire..."
mariadbd-safe --nowatch --datadir=/var/lib/mysql &

echo "Attente de MariaDB..."
until mysqladmin ping --silent; do
  sleep 1
done

if [ ! -f /var/lib/mysql/toto ]; then
echo "Création ou mise à jour de la base et user MySQL..."
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS $SQL_DATABASE;
DROP USER IF EXISTS '$SQL_USER'@'%';
CREATE USER '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD';
GRANT ALL PRIVILEGES ON $SQL_DATABASE.* TO '$SQL_USER'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '$SQL_ROOT_PASSWORD';
FLUSH PRIVILEGES;
exit
EOF

touch /var/lib/mysql/toto
fi
echo "Arrêt du serveur temporaire..."
mysqladmin -u root -p"$SQL_ROOT_PASSWORD" shutdown

echo "Démarrage normal MariaDB..."
exec "$@"