#!/bin/bash
set -e


# Initialize DB if empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    echo "Starting temporary MariaDB server for initialization..."
    mysqld_safe --datadir=/var/lib/mysql &
    pid="$!"

    # Wait until ready
    until mariadb -u root -e "SELECT 1;" &>/dev/null; do
        echo "Waiting for MariaDB to be ready..."
        sleep 2
    done

    echo "Running initial SQL setup..."
    mariadb -u root <<-EOSQL
        CREATE DATABASE IF NOT EXISTS ${DB_NAME};
        CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}';
        GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
        
        CREATE USER IF NOT EXISTS '${GRAFANA_DB_USER}'@'%' IDENTIFIED BY '${GRAFANA_DB_PASSWORD}';
        GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${GRAFANA_DB_USER}'@'%';
        GRANT SELECT ON mysql.* TO '${GRAFANA_DB_USER}'@'%';
        
        FLUSH PRIVILEGES;
EOSQL

    # Kill background mysqld
    echo "Shutting down temporary MariaDB server..."
    kill "$pid"
    wait "$pid" || true

    echo "MariaDB init complete. Starting server..."
else
    echo "MariaDB data directory already initialized. Starting server..."
fi

exec mysqld --user=mysql --datadir=/var/lib/mysql
