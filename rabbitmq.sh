#!/bin/bash

# Update OS with latest patches
echo "Updating OS with latest patches..."
sudo yum update -y

# Set EPEL Repository
echo "Setting up EPEL repository..."
sudo yum install epel-release -y

# Install Dependencies
echo "Installing dependencies..."
sudo yum install wget -y

# Install RabbitMQ
echo "Installing RabbitMQ..."
cd /tmp/
sudo yum install rabbitmq-server -y

# Start RabbitMQ Server
echo "Starting RabbitMQ server..."
sudo systemctl start rabbitmq-server
sudo systemctl enable rabbitmq-server
sudo systemctl status rabbitmq-server

# Setup access to user 'test' and make it admin
echo "Setting up RabbitMQ user 'test' and making it an admin..."
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator

# Restart RabbitMQ Server to apply new settings
echo "Restarting RabbitMQ server..."
sudo systemctl restart rabbitmq-server

# Configure Firewall to allow access to RabbitMQ on port 5672
echo "Configuring firewall to allow access to RabbitMQ on port 5672..."
sudo firewall-cmd --add-port=5672/tcp --permanent
sudo firewall-cmd --reload

# Ensure RabbitMQ server is running and enabled
echo "Ensuring RabbitMQ server is running and enabled..."
sudo systemctl start rabbitmq-server
sudo systemctl enable rabbitmq-server
sudo systemctl status rabbitmq-server

echo "RabbitMQ setup complete."
