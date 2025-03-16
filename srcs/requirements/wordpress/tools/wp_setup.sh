#!/bin/sh

# Install WP-CLI
if [ ! -f "/usr/local/bin/wp" ]; then
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
fi

# Create WordPress directory
mkdir -p /var/www/html

# Wait for MariaDB to be ready
until mysqladmin ping -h mariadb --silent; do
    echo "Waiting for MariaDB..."
    sleep 2
done

# Setup WordPress if not already installed
cd /var/www/html
if [ ! -f "wp-config.php" ]; then
    wp core download --allow-root
    wp config create --dbname=${MYSQL_DATABASE} --dbuser=${MYSQL_USER} --dbpass=${MYSQL_PASSWORD} --dbhost=mariadb --allow-root
    wp core install --url=${DOMAIN_NAME} --title=${WP_TITLE} --admin_user=${WP_ADMIN_USER} --admin_password=${WP_ADMIN_PASSWORD} --admin_email=${WP_ADMIN_EMAIL} --allow-root
    wp user create ${WP_USER} ${WP_USER_EMAIL} --user_pass=${WP_USER_PASSWORD} --role=author --allow-root
fi

# Set proper permissions
chown -R nobody:nobody /var/www/html

# Start PHP-FPM
exec php-fpm8 -F
