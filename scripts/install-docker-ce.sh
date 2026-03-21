#!/bin/bash

# Script to install Docker on Ubuntu

set -e  # Exit immediately if a command exits with a non-zero status.

# Update the package index
sudo apt-get update

# Install prerequisites
sudo apt-get install -y ca-certificates curl

# Create a directory for Docker's GPG key and download it
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker's official repository to Apt sources
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update the package index again to include Docker's repository
sudo apt-get update

# Install Docker packages
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add the current user to the Docker group
sudo gpasswd -a $USER docker

# Activate the changes to groups
newgrp docker

# Test Docker installation
docker run hello-world
