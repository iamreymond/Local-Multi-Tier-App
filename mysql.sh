#!/bin/bash

sudo -i
yum update -y
yum install mariadb-server -y

systemctl start mariadb
systemctl enable mariadb

mysql -u root -padmin123 <<EOF
create database accounts;
grant all privileges on accounts.* TO 'admin'@'%' identified by 'admin123';
FLUSH PRIVILEGES;
exit;
EOF

mysql -u root -padmin123 accounts < src/main/resources/db_backup.sql

mysql -u root -padmin123 accounts <<EOF
show tables;
exit;
EOF

systemctl restart mariadb

systemctl start firewalld
systemctl enable firewalld

firewall-cmd --get-active-zones
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --reload

systemctl restart mariadb

