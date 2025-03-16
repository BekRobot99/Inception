FROM alpine:3.16

RUN apk update && \
    apk add --no-cache php8 php8-fpm php8-mysqli php8-json php8-curl php8-dom php8-exif \
    php8-fileinfo php8-mbstring php8-openssl php8-xml php8-zip php8-phar \
    mysql-client wget

RUN mkdir -p /var/www/html /run/php /var/log/php8

COPY ./conf/www.conf /etc/php8/php-fpm.d/www.conf

COPY ./tools/wp_setup.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/docker-entrypoint.sh"]
