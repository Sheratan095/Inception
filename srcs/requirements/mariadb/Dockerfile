FROM debian:11

RUN apt-get update && apt-get install -y mariadb-server mariadb-client procps \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 3306

COPY ./tools/mariadb.sh /mariadb.sh
RUN chmod +x /mariadb.sh

COPY ./conf/50-server.conf /etc/mysql/mariadb.conf.d/99-custom.cnf

RUN mkdir -p /var/lib/mysql /var/run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql /var/run/mysqld \
    && chmod -R 755 /var/lib/mysql /var/run/mysqld

ENTRYPOINT ["/mariadb.sh"]
