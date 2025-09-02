FROM frappe/erpnext:latest

# Copy your startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Install postgres client to run pg_isready
USER root
RUN apt-get update && apt-get install -y postgresql-client
USER frappe

ENTRYPOINT ["/start.sh"]
