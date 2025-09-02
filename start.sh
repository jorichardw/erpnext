#!/bin/bash
set -e

echo "Waiting for database..."
until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER"; do
  sleep 3
done
echo "Database is ready!"

cd /home/frappe/frappe-bench

export PGSSLMODE=require

if [ ! -d "/home/frappe/frappe-bench/sites/${SITE_NAME}" ]; then
  echo "Creating new site: ${SITE_NAME}"
  bench new-site "${SITE_NAME}" \
    --db-type postgres \
    --db-host "${DB_HOST}" \
    --db-port "${DB_PORT}" \
    --db-name "${DB_NAME}" \
    --db-user "${DB_USER}" \
    --db-password "${DB_PASSWORD}" \
    --admin-password Admin12345 \
    --db-root-password "${DB_PASSWORD}"

      jq '. + {"db_sslmode":"require"}' sites/${SITE_NAME}/site_config.json > sites/${SITE_NAME}/site_config_tmp.json
  mv sites/${SITE_NAME}/site_config_tmp.json sites/${SITE_NAME}/site_config.json

  bench --site "${SITE_NAME}" install-app erpnext
fi

bench serve --port 8000
