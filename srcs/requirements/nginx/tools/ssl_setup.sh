#!/bin/sh

# Create directory for SSL certificates
mkdir -p /etc/nginx/ssl

# Generate self-signed SSL certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=XX/ST=State/L=City/O=Organization/CN=${DOMAIN_NAME}"

# Set appropriate permissions
chmod 600 /etc/nginx/ssl/nginx.key
chmod 644 /etc/nginx/ssl/nginx.crt

echo "SSL certificate generated successfully"
ls -la /etc/nginx/ssl/
