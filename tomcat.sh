#!/bin/bash

sudo -i
yum update -y
yum install java-11-openjdk java-11-openjdk-devel
yum install git maven wget -y

cd /tmp/
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz
tar -xzvf apache-tomcat-9.0.75.tar.gz
useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat

cp -r /tmp/apache-tomcat-9.0.75/* /usr/local/tomcat/
chown -R tomcat.tomcat /usr/local/tomcat

SERVICE_FILE="/etc/systemd/system/tomcat.service"
TOMCAT_USER="tomcat"
TOMCAT_DIR="/usr/local/tomcat"
JAVA_DIR="/usr/lib/jvm/jre"

cat <<EOF > $SERVICE_FILE
[Unit]
Description=Tomcat
After=network.target

[Service]
User=$TOMCAT_USER
WorkingDirectory=$TOMCAT_DIR
Environment=JRE_HOME=$JAVA_DIR
Environment=JAVA_HOME=$JAVA_DIR
Environment=CATALINA_HOME=$TOMCAT_DIR
Environment=CATALINE_BASE=$TOMCAT_DIR
ExecStart=$TOMCAT_DIR/bin/catalina.sh run
ExecStop=$TOMCAT_DIR/bin/shutdown.sh
SyslogIdentifier=tomcat-%i

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable tomcat
systemctl start tomcat

systemctl start firewalld
systemctl enable firewalld
firewalld-cmd --get-actives-zones
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --reload

cd ../vagrant
mvn install
systemctl stop tomcat

rm -rf /usr/local/tomcat/webapps/ROOT*
cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
systemctl start tomcat
chown tomcat.tomcat /usr/local/tomcat/webapps -R

systemctl restart tomcat

