#!/bin/bash

# Creates the directory /etc/nginx/ssl if it doesn’t exist (-p avoids errors if it already exists).
mkdir -p /etc/nginx/ssl

# Starts Nginx in the foreground instead of the default daemon mode.
# In Docker, the container runs as long as its main process runs.
# If Nginx runs as a background daemon (default), Docker thinks the container finished and stops immediately.
# daemon off; keeps Nginx attached to the main process, keeping the container alive.
nginx -g 'daemon off;'

echo "Nginx started"