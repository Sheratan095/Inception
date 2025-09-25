FROM debian:11

# Install Nginx + OpenSSL
RUN apt-get update && apt-get install -y nginx openssl

# Generate self-signed SSL cert (valid 1 year)
RUN mkdir -p /etc/ssl/private /etc/ssl/certs && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
      -keyout /etc/ssl/private/nginx-selfsigned.key \
      -out /etc/ssl/certs/nginx-selfsigned.crt \
      -subj "/C=IT/L=Florence/O=42/OU=Student/CN=localhost"

# Copy your custom Nginx config
COPY Conf/nginx.conf /etc/nginx/sites-available/default

# Copy startup script, allow execution and execute it
COPY Tools/setup.sh /
RUN chmod +x /setup.sh
CMD ["/setup.sh"]
