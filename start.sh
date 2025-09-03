#!/bin/bash
set -e

echo "⏳ Waiting for database..."
until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER"; do
  sleep 3
done
echo "✅ Database is ready!"

SITE_PATH="/home/frappe/frappe-bench/sites/${SITE_NAME}"

if [ ! -d "$SITE_PATH" ]; then
  echo "📦 Creating new site: $SITE_NAME"

  # Set PostgreSQL password for root connection
  export PGPASSWORD="$DB_PASSWORD"

  bench new-site ${SITE_NAME} \
    --db-type postgres \
    --db-host ${DB_HOST} \
    --db-port ${DB_PORT} \
    --db-name ${DB_NAME} \
    --db-user ${DB_USER} \
    --db-password ${DB_PASSWORD} \
    --admin-password Admin12345 \
    --mariadb-user-host-login-scope='%'  # Replaced deprecated --no-mariadb-socket

  echo "⬇️ Getting ERPNext app..."
  bench get-app erpnext

  echo "📥 Installing ERPNext..."
  bench --site ${SITE_NAME} install-app erpnext
else
  echo "✅ Site already exists, skipping creation."
fi

echo "🚀 Starting development server..."
bench serve --port 8000
