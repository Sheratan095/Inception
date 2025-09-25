#!/bin/bash

mkdir -p /etc/nginx/ssl

nginx -g 'daemon off;'

echo "Nginx started"