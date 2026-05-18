#!/bin/bash
set -e

INSTALL_DIR="${DEBINIT_DIR:-$HOME/.debinit}"

log() { echo -e "\e[32m[debinit] $1\e[0m"; }

cd "$INSTALL_DIR"

# Mirrors `just all` → exec + shell + brew (see Justfile)
log "Adding permissions..."
sudo chmod +x scripts/*.sh

log "Installing APT packages and setup ohmyzsh..."
bash scripts/apt-install-packages.sh
bash scripts/install-oh-my-zsh.sh

log "Installing Brew packages..."
bash scripts/brew-install-packages.sh

if [ -t 0 ] && [ -t 1 ]; then
	log "Starting zsh (exit to finish)..."
	zsh
fi

log "Done! Restart your shell or run: exec zsh"
