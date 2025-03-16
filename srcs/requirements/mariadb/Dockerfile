FROM alpine:3.16

RUN apk update && \
    apk add --no-cache mariadb mariadb-client && \
    mkdir -p /var/lib/mysql /var/log/mysql

COPY ./conf/my.cnf /etc/my.cnf

RUN chown -R mysql:mysql /var/lib/mysql /var/log/mysql && \
    chmod 777 /var/run/mysqld

COPY ./tools/db_init.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/docker-entrypoint.sh"]
