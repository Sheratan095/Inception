#!/bin/bash
set -e

# Initialize DB if empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# Start mysqld in background for initialization
mysqld_safe --datadir=/var/lib/mysql &
pid="$!"

# Wait until ready
until mariadb -u root -e "SELECT 1;" &>/dev/null; do
    echo "Waiting for MariaDB to be ready..."
    sleep 2
done

# Run init SQL only once
mariadb -u root <<-EOSQL
    CREATE DATABASE IF NOT EXISTS ${DB_NAME};
    CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
    GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
    FLUSH PRIVILEGES;
EOSQL

# Kill background mysqld
kill "$pid"
wait "$pid" || true

echo "MariaDB init complete. Starting server..."
exec mysqld --user=mysql --datadir=/var/lib/mysql
