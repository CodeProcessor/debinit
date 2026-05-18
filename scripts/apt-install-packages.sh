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
# Filter out already-installed packages
TO_INSTALL=()
for pkg in "${PACKAGES[@]}"; do
    if ! dpkg -s "$pkg" &>/dev/null; then
        TO_INSTALL+=("$pkg")
    fi
done

if [ ${#TO_INSTALL[@]} -eq 0 ]; then
    log "All packages already installed."
else
    log "Installing: ${TO_INSTALL[*]}"
    sudo nala install -y "${TO_INSTALL[@]}"
fi

# add tmux config


# add vim config

