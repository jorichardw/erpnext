FROM frappe/erpnext:latest

# Copy start.sh to frappe home directory, already executable
COPY start.sh /home/frappe/start.sh

# Switch to frappe user (default user, can be omitted if already default)
USER frappe

# NO chmod here

ENTRYPOINT ["/home/frappe/start.sh"]
