#!/bin/bash
# Update the package repository
sudo apt-get update -y

# Install Nginx web server
sudo apt-get install nginx -y

# Start and enable Nginx so it runs automatically on boot
sudo systemctl start nginx
sudo systemctl enable nginx

# Overwrite the default Nginx index page with a custom title
echo "<h1>Welcome to Secure Azure Web Architecture Project</h1>" | sudo tee /var/www/html/index.html