#!/bin/bash

# Update OS with latest patches
echo "Updating OS with latest patches..."
sudo apt update -y
sudo apt upgrade -y

# Install Nginx
echo "Installing Nginx..."
sudo apt install nginx -y

# Create Nginx configuration file for vproapp
echo "Creating Nginx configuration file for vproapp..."
sudo tee /etc/nginx/sites-available/vproapp > /dev/null <<EOL
upstream vproapp {
    server app01:8080;
}
server {
    listen 80;
    location / {
        proxy_pass http://vproapp;
    }
}
EOL

# Remove default Nginx configuration
echo "Removing default Nginx configuration..."
sudo rm -rf /etc/nginx/sites-enabled/default

# Create a symbolic link to activate the new website configuration
echo "Activating the new website configuration..."
sudo ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp

# Restart Nginx to apply the changes
echo "Restarting Nginx..."
sudo systemctl restart nginx

echo "Nginx setup complete."
