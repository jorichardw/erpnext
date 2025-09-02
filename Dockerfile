FROM frappe/erpnext:latest

# Copy start.sh to frappe home directory
COPY start.sh /home/frappe/start.sh

# Change ownership and permissions as frappe user
USER frappe
RUN chmod +x /home/frappe/start.sh

ENTRYPOINT ["/home/frappe/start.sh"]
