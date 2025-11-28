#!/bin/bash
set -e

apt update -y
apt install -y default-mysql-server

# Enable and start DB service (works for both MariaDB & MySQL)
systemctl enable mysql || systemctl enable mariadb
systemctl start mysql || systemctl start mariadb
