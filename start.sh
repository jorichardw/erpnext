#!/bin/bash
set -e

echo "Waiting for database..."
until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER"; do
  sleep 3
done
echo "Database is ready!"

# Activate bench environment
cd /home/frappe/frappe-bench

# Create site if it doesn't already exist
if [ ! -d "/home/frappe/frappe-bench/sites/${SITE_NAME}" ]; then
  echo "Creating new site: ${SITE_NAME}"
  bench new-site ${SITE_NAME} \
    --db-type postgres \
    --db-host ${DB_HOST} \
    --db-port ${DB_PORT} \
    --db-name ${DB_NAME} \
    --db-user ${DB_USER} \
    --db-password ${DB_PASSWORD} \
    --admin-password Admin12345 \
    --db-root-password ${DB_PASSWORD} \
    --install-app erpnext \
    --no-input

  echo "Site ${SITE_NAME} created and ERPNext installed!"
fi

# Start production WSGI server
echo "Starting production server on port 8000..."
exec bench serve --port 8000
