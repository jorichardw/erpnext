#!/bin/bash
set -e

# Wait for database
echo "⏳ Waiting for database..."
until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER"; do
  sleep 3
done
echo "✅ Database is ready!"

# Set PostgreSQL password
export PGPASSWORD="$DB_PASSWORD"

# Create site if it doesn't exist
if [ ! -f "/home/frappe/frappe-bench/sites/${SITE_NAME}/site_config.json" ]; then
  echo "📦 Creating new site: $SITE_NAME"
  
  bench new-site ${SITE_NAME} \
    --db-type postgres \
    --db-host ${DB_HOST} \
    --db-port ${DB_PORT} \
    --db-name ${DB_NAME} \
    --db-user ${DB_USER} \
    --db-password ${DB_PASSWORD} \
    --admin-password ${ADMIN_PASSWORD:-Admin12345} \
    --mariadb-user-host-login-scope='%' \
    --force
  
  # Install ERPNext if not already installed
  if [ ! -d "/home/frappe/frappe-bench/apps/erpnext" ]; then
    bench get-app erpnext
  fi
  
  bench --site ${SITE_NAME} install-app erpnext
else
  echo "✅ Site already exists."
  bench --site ${SITE_NAME} migrate
fi

echo "🚀 Starting server..."
bench serve --port 8000
