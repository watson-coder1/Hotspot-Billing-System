#!/bin/bash

# Exit on error
set -e

echo "[INFO] Starting MySQL initialization..."

# Wait for MySQL to be ready
echo "[INFO] Waiting for MySQL to be ready..."
counter=0
max_tries=30

while true; do
    if mysqladmin ping -h"localhost" -u"root" -p"${MYSQL_ROOT_PASSWORD}" --silent; then
        break
    fi

    counter=$((counter + 1))
    if [ $counter -gt $max_tries ]; then
        echo "[ERROR] Failed to connect to MySQL after $max_tries attempts"
        exit 1
    fi
    echo "[INFO] Waiting for MySQL to be ready... ($counter/$max_tries)"
    sleep 2
done

echo "[INFO] MySQL is ready. Setting up database and users..."

# Setup database and permissions
mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    CREATE DATABASE IF NOT EXISTS \`${RADIUS_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
    GRANT ALL PRIVILEGES ON \`${RADIUS_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
    FLUSH PRIVILEGES;"

# Import SQL file if exists
if [ -f "/tmp/radius_schema.sql" ]; then
    echo "[INFO] Importing SQL file..."
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" "${RADIUS_DATABASE}" < /tmp/radius_schema.sql
    echo "[INFO] SQL import completed."
else
    echo "[INFO] No SQL file found at /tmp/radius_schema.sql"
fi

echo "[INFO] MySQL initialization completed successfully!"