#!/bin/bash

sudo -i

yum update -y
yum install rabbitmq-server -y

systemctl start rabbitmq-server
systemctl enable rabbitmq-server

sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
rabbitmqctl add_user test test
rabbitmqctl set_user_tags test administrator

systemctl start firewalld
systemctl enable firewalld
firewall-cmd --add-port=5671/tcp --permanent
firewall-cmd --add-port=5672/tcp --permanent
firewall-cmd --reload

systemctl restart rabbitmq-server
reboot

sudo systemctl restart rabbitmq-server
