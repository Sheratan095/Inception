FROM debian:11

# Install PHP, PHP-FPM, PHP extensions, and MySQL client
RUN apt-get update && apt-get install -y vim wget php7.4-fpm php-mysql default-mysql-client

# Install WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp

# Copy custom PHP-FPM config file
COPY /Conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

COPY /Tools/wordpress.sh /

# 21 is for FTP, 9000 is for PHP-FPM
EXPOSE 9000 21

# Give execution rights to the startup script and run it
RUN chmod +x /wordpress.sh
CMD ["/wordpress.sh"]