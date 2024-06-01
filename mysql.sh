#!/bin/bash

# Update OS with latest patches
echo "Updating OS with latest patches..."
yum update -y

# Set Repository
echo "Setting up repository..."
yum install epel-release -y

# Install MariaDB package and Git
echo "Installing MariaDB and Git..."
yum install git mariadb-server -y

# Start and enable MariaDB server
echo "Starting and enabling MariaDB server..."
systemctl start mariadb
systemctl enable mariadb

# Run MySQL secure installation script
echo "Running MySQL secure installation..."
mysql_secure_installation <<EOF

Y
admin123
admin123
Y
n
Y
Y
EOF

# Set database name and users
echo "Setting up database and users..."
mysql -u root -padmin123 <<EOF
create database accounts;
grant all privileges on accounts.* TO 'admin'@'%' identified by 'admin123';
FLUSH PRIVILEGES;
exit;
EOF

# Download source code and initialize database
echo "Downloading source code and initializing database..."
git clone -b main https://github.com/hkhcoder/vprofile-project.git
cd vprofile-project
mysql -u root -padmin123 accounts < src/main/resources/db_backup.sql

# Verify tables in the database
mysql -u root -padmin123 accounts <<EOF
show tables;
exit;
EOF

# Restart MariaDB server
echo "Restarting MariaDB server..."
systemctl restart mariadb

# Start the firewall and allow MariaDB to be accessed from port 3306
echo "Configuring firewall to allow MariaDB access..."
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --get-active-zones
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --reload

# Restart MariaDB server to apply all changes
echo "Restarting MariaDB server to apply all changes..."
systemctl restart mariadb

echo "Setup complete."
