FROM debian:bullseye

# Install required packages
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg \
    software-properties-common \
    adduser \
    libfontconfig1 \
    musl \
    && rm -rf /var/lib/apt/lists/*

# Create grafana user
RUN groupadd -r grafana && useradd -r -g grafana grafana

# Download and install Grafana
RUN wget -q -O /tmp/grafana.deb https://dl.grafana.com/enterprise/release/grafana-enterprise_10.1.5_amd64.deb \
    && dpkg -i /tmp/grafana.deb \
    && rm /tmp/grafana.deb

# Create necessary directories
RUN mkdir -p /var/lib/grafana /var/log/grafana /etc/grafana \
    && chown -R grafana:grafana /var/lib/grafana /var/log/grafana /etc/grafana

# Copy configuration files
COPY conf/grafana.ini /etc/grafana/grafana.ini
COPY tools/grafana.sh /usr/local/bin/grafana.sh

# Make script executable
RUN chmod +x /usr/local/bin/grafana.sh

# Set ownership
RUN chown grafana:grafana /etc/grafana/grafana.ini /usr/local/bin/grafana.sh

# Expose Grafana port
EXPOSE 3000

# Switch to grafana user
USER grafana

# Set working directory
WORKDIR /usr/share/grafana

# Run the startup script
CMD ["/usr/local/bin/grafana.sh"]