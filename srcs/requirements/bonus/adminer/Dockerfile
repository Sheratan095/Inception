FROM debian:12

RUN apt-get update && apt-get upgrade -y && apt-get install -y vim wget php8.2-fpm php-mysql

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

COPY tools/adminer.sh /

EXPOSE 9001

RUN chmod +x /adminer.sh

CMD ["/adminer.sh"]