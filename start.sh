#!/bin/bash
set -e

# Wait for DB to be ready (optional but recommended)
echo "Waiting for database..."
until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER"; do
  sleep 3
done
echo "Database is ready!"

# Check if site exists, create if not
if [ ! -d "/home/frappe/frappe-bench/sites/${SITE_NAME}" ]; then
  bench new-site ${SITE_NAME} \
    --db-type postgres \
    --db-host ${DB_HOST} \
    --db-port ${DB_PORT} \
    --db-name ${DB_NAME} \
    --db-user ${DB_USER} \
    --db-password ${DB_PASSWORD} \
    --admin-password Admin12345 \
    --no-mariadb-check
  bench --site ${SITE_NAME} install-app erpnext
fi

# Start the bench
bench start
