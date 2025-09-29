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
COPY conf/nginx.conf /etc/nginx/sites-available/default

# Copy custom HTML files to static location
COPY html/ /usr/share/nginx/html/

# Copy startup script, allow execution and execute it
COPY tools/nginx.sh /
RUN chmod +x /nginx.sh
CMD ["/nginx.sh"]
