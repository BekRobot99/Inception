#!/bin/sh

# Create required directories
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Initialize database if not already done
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    # Create temp file for SQL setup
    tfile=$(mktemp)
    
    # Set up SQL commands
    cat > $tfile << EOT
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOT

    # Execute commands and clean up
    /usr/bin/mysqld --user=mysql --bootstrap < $tfile
    rm -f $tfile
fi

# Start MariaDB server
exec /usr/bin/mysqld --user=mysql --console
