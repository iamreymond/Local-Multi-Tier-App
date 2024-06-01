#!/bin/bash

# Update OS with latest patches
echo "Updating OS with latest patches..."
sudo yum update -y

# Set EPEL Repository
echo "Setting up EPEL repository..."
sudo yum install epel-release -y

# Install Dependencies
echo "Installing dependencies..."
sudo yum install -y java-11-openjdk java-11-openjdk-devel git maven wget

# Change directory to /tmp
echo "Changing directory to /tmp..."
cd /tmp/

# Download and extract Tomcat package
echo "Downloading and extracting Tomcat package..."
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz
tar -xzvf apache-tomcat-9.0.75.tar.gz

# Add tomcat user
echo "Adding tomcat user..."
sudo useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat

# Copy data to tomcat home directory
echo "Copying Tomcat data to home directory..."
sudo mkdir -p /usr/local/tomcat
sudo cp -r /tmp/apache-tomcat-9.0.75/* /usr/local/tomcat/

# Make tomcat user owner of tomcat home directory
echo "Changing ownership of Tomcat home directory..."
sudo chown -R tomcat:tomcat /usr/local/tomcat

# Create Tomcat service file
echo "Creating Tomcat service file..."
sudo tee /etc/systemd/system/tomcat.service > /dev/null <<EOL
[Unit]
Description=Tomcat
After=network.target

[Service]
User=tomcat
WorkingDirectory=/usr/local/tomcat
Environment=JRE_HOME=/usr/lib/jvm/jre
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINA_BASE=/usr/local/tomcat
ExecStart=/usr/local/tomcat/bin/catalina.sh run
ExecStop=/usr/local/tomcat/bin/shutdown.sh
SyslogIdentifier=tomcat-%i

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd files
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

# Start and enable Tomcat service
echo "Starting and enabling Tomcat service..."
sudo systemctl start tomcat
sudo systemctl enable tomcat

# Configure firewall to allow access to Tomcat on port 8080
echo "Configuring firewall to allow access to Tomcat on port 8080..."
sudo systemctl start firewalld
sudo systemctl enable firewalld
sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
sudo firewall-cmd --reload

# Download Source code
echo "Downloading source code..."
cd /tmp/
git clone -b main https://github.com/hkhcoder/vprofile-project.git

# Update configuration
echo "Updating configuration..."
cd vprofile-project
# Replace the following line with actual configuration updates
sed -i 's/your_backend_server_details/new_backend_server_details/' src/main/resources/application.properties

# Build code
echo "Building the project..."
mvn install

# Deploy artifact to Tomcat
echo "Deploying artifact to Tomcat..."
sudo systemctl stop tomcat
sudo rm -rf /usr/local/tomcat/webapps/ROOT*
sudo cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
sudo chown -R tomcat:tomcat /usr/local/tomcat/webapps
sudo systemctl start tomcat
sudo systemctl restart tomcat

echo "Tomcat and vprofile-project setup complete."
