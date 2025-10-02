#!/bin/bash
set -e


# Initialize DB if our custom database doesn't exist
if [ ! -d "/var/lib/mysql/${DB_NAME}" ]; then
    echo "Initializing MariaDB data directory..."
    
    # Only run mariadb-install-db if mysql directory doesn't exist
    if [ ! -d "/var/lib/mysql/mysql" ]; then
        mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    fi

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
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
        CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
        GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
        
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

echo "Starting MariaDB server..."
mysqld --user=mysql --datadir=/var/lib/mysql
