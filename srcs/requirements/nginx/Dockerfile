FROM alpine:3.16

RUN apk update && \
    apk add --no-cache nginx openssl && \
    mkdir -p /var/www/html

COPY ./conf/nginx.conf /etc/nginx/nginx.conf

COPY ./tools/ssl_setup.sh /tmp/
RUN chmod +x /tmp/ssl_setup.sh

ENV DOMAIN_NAME=localhost
RUN /tmp/ssl_setup.sh

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
