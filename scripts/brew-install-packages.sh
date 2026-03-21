#!/bin/bash

# Script to install Homebrew and essential packages using Homebrew on Ubuntu

# Function to install Homebrew
install_brew() {
    echo "Installing Homebrew..."

    # Check if Homebrew is already installed
    if command -v brew >/dev/null 2>&1; then
        echo "Homebrew is already installed. Skipping installation."
    else
        # Install Homebrew
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH (for Linux systems)
        if [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        fi
    fi

    echo "Homebrew installation complete."
}

# Function to install packages using Homebrew
install_packages() {
    echo "Installing packages using Homebrew..."

    # List of packages to install
    PACKAGES=(
        gcc
        nvim
        htop
        btop
        fzf
        atuin
        zoxide
        bat
        tldr
        nerdfetch
        eza
        ripgrep
        ranger
    )
    # install with brew automatically without user interaction
    brew install "${PACKAGES[@]}" --no-interaction
    echo "All packages installed successfully."

    # change eza theme
    mkdir -p ~/.config/eza
    wget -O ~/.config/eza/theme.yml https://raw.githubusercontent.com/eza-community/eza-themes/refs/heads/main/themes/dracula.yml
    
}

# Function to configure zshrc with aliases and commands
configure_zshrc() {
    echo "Configuring .zshrc with aliases and commands..."

    # Define the commands to add to .zshrc
    # 'alias inv=nvim $(fzf -m --preview "cat {}")'
    ZSHRC_COMMANDS=(
        'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
        'eval "$(atuin init zsh --disable-up-arrow)"'
        'eval "$(zoxide init --cmd cd zsh)"'
        'alias vi="nvim"'
        'alias vim="nvim"'
        'alias ls="eza"'
        'alias ll="eza -alh"'
        'alias tree="eza --tree"'
        'alias cat="bat"'
        'alias ra="ranger"'
        'alias zshrc="source ~/.zshrc"'
        'alias src="source .venv/bin/python"'
        'nerdfetch'
        
    )

    # Check and add each command if not already present
    for command in "${ZSHRC_COMMANDS[@]}"; do
        if ! grep -Fxq "$command" ~/.zshrc; then
            echo "$command" >> ~/.zshrc
            echo "Added $command to .zshrc"
        fi
    done

    echo ".zshrc configuration complete."
}

# Main script execution
install_brew
install_packages
configure_zshrc