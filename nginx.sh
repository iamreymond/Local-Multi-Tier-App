#!/bin/bash

sudo -i
apt update
apt install nginx -y

cat <<EOF > /etc/nginx/sites-available/vproapp
upstream vproapp {
    server app01:8080;
}

server {
    listen 80;
    
    location / {
        proxy_pass http://vproapp;
    }
}
EOF

rm -rf /etc/nginx/sites-enabled/default
ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp
systemctl restart nginx
