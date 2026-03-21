#!/usr/bin/env bash
set -euo pipefail

echo "Installing dependencies..."
sudo nala install -y build-essential

echo "Installing Rust via rustup..."
if ! command -v rustup &>/dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "rustup already installed, updating..."
    rustup update stable
fi

echo "Installing bws..."
cargo install bws

echo "Adding cargo to PATH in ~/.zshrc..."
if ! grep -q 'cargo/bin' ~/.zshrc; then
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
    echo "PATH updated."
else
    echo "PATH already contains cargo/bin, skipping."
fi

echo "Done! Run: source ~/.zshrc"