#!/bin/bash

# Update OS with latest patches
yum update -y

# Set Repository
yum install epel-release -y

# Install MariaDB Package
yum install git mariadb-server -y

# Starting & enabling mariadb-server
systemctl start mariadb
systemctl enable mariadb

# Run mysql secure installation script
# Automating mysql_secure_installation using a here document
mysql_secure_installation <<EOF

Y
admin123
admin123
Y
n
Y
Y
EOF

# Set DB name and users
mysql -u root -padmin123 <<MYSQL_SCRIPT
CREATE DATABASE accounts;
GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'%' IDENTIFIED BY 'admin123';
FLUSH PRIVILEGES;
EXIT;
MYSQL_SCRIPT

# Download Source code & Initialize Database
git clone -b main https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project
mysql -u root -padmin123 accounts < src/main/resources/db_backup.sql

# Verify tables
mysql -u root -padmin123 accounts <<MYSQL_VERIFY
SHOW TABLES;
EXIT;
MYSQL_VERIFY

# Restart mariadb-server
systemctl restart mariadb

# Starting the firewall and allowing the mariadb to access from port no. 3306
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --get-active-zones
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --reload

# Restart mariadb-server again to ensure all changes take effect
systemctl restart mariadb

echo "MariaDB setup and configuration completed successfully."
