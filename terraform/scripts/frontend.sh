#!/bin/bash
apt update -y
apt install -y nginx
echo "<h1>Frontend Tier Working</h1>" > /var/www/html/index.html
systemctl restart nginx
