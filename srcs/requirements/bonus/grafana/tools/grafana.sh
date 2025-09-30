#!/bin/bash

# Grafana startup script

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}[GRAFANA]${NC} Starting Grafana service..."

# Check if grafana configuration exists
if [ ! -f /etc/grafana/grafana.ini ]; then
    echo -e "${RED}[GRAFANA ERROR]${NC} Configuration file not found!"
    exit 1
fi

# Create data directory if it doesn't exist
if [ ! -d /var/lib/grafana ]; then
    echo -e "${YELLOW}[GRAFANA]${NC} Creating data directory..."
    mkdir -p /var/lib/grafana
fi

# Create logs directory if it doesn't exist
if [ ! -d /var/log/grafana ]; then
    echo -e "${YELLOW}[GRAFANA]${NC} Creating logs directory..."
    mkdir -p /var/log/grafana
fi

echo -e "${GREEN}[GRAFANA]${NC} Configuration validated successfully"
echo -e "${GREEN}[GRAFANA]${NC} Starting Grafana server on port 3000..."

# Start Grafana server without PID file (Docker handles process management)
exec /usr/share/grafana/bin/grafana-server \
    --config=/etc/grafana/grafana.ini \
    --packaging=docker \
    cfg:default.log.mode=console \
    cfg:default.paths.data=/var/lib/grafana \
    cfg:default.paths.logs=/var/log/grafana \
    cfg:default.paths.plugins=/var/lib/grafana/plugins \
    cfg:default.paths.provisioning=/etc/grafana/provisioning