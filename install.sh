#!/bin/bash
set -e

REPO="https://github.com/CodeProcessor/debinit"
INSTALL_DIR="$HOME/.debinit"

log() { echo -e "\e[32m[debinit] $1\e[0m"; }
err() { echo -e "\e[31m[debinit] $1\e[0m" >&2; exit 1; }

# Ensure curl and git are available
command -v curl >/dev/null 2>&1 || err "curl is required but not installed."
command -v git  >/dev/null 2>&1 || { log "git not found, installing..."; sudo apt-get install -y git; }

# Clone or update the repo
if [ -d "$INSTALL_DIR/.git" ]; then
    log "Updating existing repo at $INSTALL_DIR..."
    git -C "$INSTALL_DIR" pull --ff-only
else
    log "Cloning debinit to $INSTALL_DIR..."
    git clone "$REPO" "$INSTALL_DIR"
fi

chmod +x "$INSTALL_DIR/scripts/"*.sh

# Install just
if ! command -v just >/dev/null 2>&1; then
    log "Installing just..."
    curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin
fi

log "Running just all..."
cd "$INSTALL_DIR" && just all

log "Done! Restart your shell or run: exec zsh"
