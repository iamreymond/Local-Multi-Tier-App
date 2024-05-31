#!/bin/bash

echo "CHANGE USER TO ROOT"
sudo -i

echo "YUM UPDATE"
yum update -y
yum install memcached -y

echo "SYSTEMCTL START MEMCAHCED"
systemctl start memcached
systemctl enable memcached
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached
systemctl restart memcached

echo "SYSTEMCTL START FIREWALLD"
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --add-port=11211/tcp
firewall-cmd --runtime-to-permanent
firewall-cmd --add-port=11111/udp
firewall-cmd --runtime-to-permanent
memcached -p 11211 -U 11111 -u memcached -d

echo "FINISHED SCRIPTS"

