#!/bin/bash

# Creates the directory /etc/nginx/ssl if it doesn't exist (-p avoids errors if it already exists).
mkdir -p /etc/nginx/ssl

# Copy custom HTML files to the web root after volume mount
cp -r /usr/share/nginx/html/* /var/www/html/ 2>/dev/null || true

# Starts Nginx in the foreground instead of the default daemon mode.
# In Docker, the container runs as long as its main process runs.
# If Nginx runs as a background daemon (default), Docker thinks the container finished and stops immediately.
# daemon off; keeps Nginx attached to the main process, keeping the container alive.
nginx -g 'daemon off;'

echo "Nginx started"
#!/bin/bash

# Creates the directory /etc/nginx/ssl if it doesn't exist (-p avoids errors if it already exists).
mkdir -p /etc/nginx/ssl

# Wait for WordPress to be ready before starting nginx
echo "Waiting for WordPress files to be ready..."
while [ ! -f /var/www/html/index.php ]; do
    sleep 2
done

echo "WordPress files detected, starting Nginx..."

# Starts Nginx in the foreground instead of the default daemon mode.
# In Docker, the container runs as long as its main process runs.
# If Nginx runs as a background daemon (default), Docker thinks the container finished and stops immediately.
# daemon off; keeps Nginx attached to the main process, keeping the container alive.
nginx -g 'daemon off;'