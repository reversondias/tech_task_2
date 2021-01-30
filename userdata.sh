#!/bin/bash
set -ex

echo "Update APT cache"
sudo apt-get update

echo "Install apcahe2 package"
sudo apt-get install -y apache2

echo "Enable Apache to allow in the firewall"
sudo ufw allow 'Apache'

echo "Enable and start apache2 service by systemctl"
sudo systemctl enable apache2
sudo systemctl start apache2

echo "Create index.html file on Apache root dir"
echo "<h1>   It works</h1>" > /var/www/html/index.html