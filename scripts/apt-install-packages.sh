#!/bin/bash
export NONINTERACTIVE=1
# Exit on error
set -e

# Function to print messages
log() {
    echo -e "\e[32m$1\e[0m"
}

# List of essential packages (excluding nala as it will be installed first)
PACKAGES=(
    build-essential
    git
    curl
    wget
    zsh
    neovim
    tmux
)

echo "Updating package list..."
sudo apt update 

echo "Installing nala first..."
sudo DEBIAN_FRONTEND=noninteractive apt install -y nala

# echo "Optimizing download locations with nala fetch..."
# sudo nala fetch --auto

echo "Installing essential packages using nala..."
sudo nala install -y "${PACKAGES[@]}"

# add tmux config


# add vim config

