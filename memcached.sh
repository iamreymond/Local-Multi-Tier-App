#!/bin/bash

# Update OS with latest patches
echo "Updating OS with latest patches..."
yum update -y

# Install, start, and enable Memcached on port 11211
echo "Installing Memcached..."
sudo yum install epel-release -y
sudo yum install memcached -y

echo "Starting and enabling Memcached..."
sudo systemctl start memcached
sudo systemctl enable memcached
sudo systemctl status memcached

# Configure Memcached to listen on all IP addresses
echo "Configuring Memcached to listen on all IP addresses..."
sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached

# Restart Memcached to apply the new configuration
echo "Restarting Memcached..."
sudo systemctl restart memcached

# Start the firewall and allow the port 11211 to access Memcached
echo "Configuring firewall to allow access to Memcached on port 11211..."
sudo firewall-cmd --add-port=11211/tcp --permanent
sudo firewall-cmd --add-port=11111/udp --permanent
sudo firewall-cmd --reload

# Start Memcached with the specified settings
echo "Starting Memcached with custom settings..."
sudo memcached -p 11211 -U 11111 -u memcached -d

echo "Memcached setup complete."
