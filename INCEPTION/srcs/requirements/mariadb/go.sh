#!/bin/bash
set -e

if [ -n "$SQL_PASSWORD_FILE" ]; then
    export SQL_PASSWORD=$(cat "$SQL_PASSWORD_FILE")
fi

echo  "maria $SQL_PASSWORD"

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
cat /run/secrets/mysql_root_password
echo 1
export SQL_ROOT_PASSWORD=$(cat /run/secrets/mysql_root_password)
echo $SQL_ROOT_PASSWORD
echo 2
exec mariadbd-safe

mysql -uroot -p"${SQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
mysql -uroot -p"${SQL_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -uroot -p"${SQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -uroot -p"${SQL_ROOT_PASSWORD}" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
mysql -uroot -p"${SQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"

mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown

exec mariadbd-safe


