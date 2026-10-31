#!/usr/bin/env bash

# week5-2: install nginx and configure it as load balancer for two backend instances.
# Usage: bash install-nginx.sh           install + configure + restart
#        bash install-nginx.sh --print   only print the generated nginx.conf

set -Eeuo pipefail

# ------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------
HSES_USERNAME="maowit00"

BACKEND_SERVER1_PORT=8245  # first server
BACKEND_SERVER2_PORT=8290  # second server (82 + unique number * 2)

CONFIG_FILE="/etc/nginx/nginx.conf"
BACKUP_FILE="${CONFIG_FILE}.bak"

# - -- - -- - -- - -- - -- - -- - --

on_error() {
  echo "" >&2
  echo "FAILED (exit $1) at line $2: $3" >&2
}

trap 'on_error $? $LINENO "$BASH_COMMAND"' ERR

# ------------------------------------------------------------------
# nginx.conf template (unquoted heredoc: $VARS are expanded, \$ stays for nginx)
# ------------------------------------------------------------------
render_config() {

cat << CONF
#user  nobody;
worker_processes  1;

#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

#pid        logs/nginx.pid;

events {
    worker_connections  1024;
}


http {
    include       mime.types;
    default_type  application/octet-stream;

    sendfile        on;

    keepalive_timeout  65;

    upstream item-management-pool {
        server 127.0.0.1:${BACKEND_SERVER1_PORT};         # first server
        server 127.0.0.1:${BACKEND_SERVER2_PORT};         # second server
    }

    server {
        listen       80;
        server_name  localhost;

        root /var/www/html;

        # Add index.php to the list if you are using PHP
        index index.html index.htm index.nginx-debian.html;

        location / {
            # First attempt to serve request as file, then
            # as directory, then fall back to displaying a 404.
            try_files \$uri \$uri/ =404;
        }

        location /api-${HSES_USERNAME}/item-management/v1 {
            proxy_pass http://item-management-pool/api-${HSES_USERNAME}/item-management/v1;
        }
    }
}
CONF
}

if [ "${1:-}" = "--print" ]
then
  render_config
  exit 0
fi

# ------------------------------------------------------------------
# Install nginx (only if missing)
# ------------------------------------------------------------------
if ! command -v nginx >/dev/null
then
  echo ">> Installing nginx"

  sudo apt update
  sudo apt install -y nginx

else
  echo ">> nginx already installed: $(nginx -v 2>&1)"
fi

# ------------------------------------------------------------------
# Configure nginx
# ------------------------------------------------------------------
if [ ! -f "$BACKUP_FILE" ]
then
  echo ">> Backup of the original config: $BACKUP_FILE"
  sudo cp "$CONFIG_FILE" "$BACKUP_FILE"
fi

echo ">> Writing $CONFIG_FILE"

render_config | sudo tee "$CONFIG_FILE" > /dev/null

echo ">> Checking configuration"

if ! sudo nginx -t
then
  echo "Invalid configuration, restoring $BACKUP_FILE" >&2
  sudo cp "$BACKUP_FILE" "$CONFIG_FILE"
  exit 1
fi

echo ">> Restarting nginx"

sudo systemctl enable nginx > /dev/null 2>&1 || true
sudo systemctl restart nginx

# ------------------------------------------------------------------
# Verify
# ------------------------------------------------------------------
for port in "$BACKEND_SERVER1_PORT" "$BACKEND_SERVER2_PORT"
do
  if ! curl -s -o /dev/null --max-time 2 "http://127.0.0.1:${port}/"; then
    echo "WARNING: no backend answering on port ${port} (start it before testing the load balancer)"
  fi
done

echo ">> Done. Test with:"

echo "   for i in 1 2 3 4; do curl -si http://localhost/api-${HSES_USERNAME}/item-management/v1/items | grep -i server-port; done"
