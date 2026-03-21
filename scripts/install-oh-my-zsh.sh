#!/bin/bash

# Got the script from - https://github.com/MNMaqsood/oh-my-zsh-installer/blob/main/install_oh_my_zsh.sh

# Exit on error
set -e

# Function to print messages
log() {
    echo -e "\e[32m$1\e[0m"
}

# Check for argument and set default if none provided
# MAKE_DEFAULT_SHELL="${1:-no}"

# Display the selected option
# log "Make Zsh default shell: $MAKE_DEFAULT_SHELL"

# Install Zsh
log "Installing Zsh..."
sudo apt update
sudo apt install -y zsh curl git

# Install Oh My Zsh if not already installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    log "Oh My Zsh is already installed at $HOME/.oh-my-zsh. Skipping installation."
else
    log "Installing Oh My Zsh..."
    export RUNZSH=yes
    export CHSH=yes
    export KEEP_ZSHRC=yes
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Change Oh My Zsh theme to candy
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="candy"/' ~/.zshrc


# Set Zsh as the default shell if requested
# if [[ "$MAKE_DEFAULT_SHELL" == "yes" ]]; then
#     log "Setting Zsh as the default shell..."
#     chsh -s $(which zsh)
# else
#     log "Zsh installation complete. Skipping setting it as the default shell."
# fi

# Install Zsh autosuggestions
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    log "Installing Zsh autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
else
    log "Zsh autosuggestions already installed. Skipping."
fi

# Install Zsh syntax highlighting
if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    log "Installing Zsh syntax highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
else
    log "Zsh syntax highlighting already installed. Skipping."
fi

# Update .zshrc to enable plugins
log "Configuring Zsh plugins in .zshrc..."
if ! grep -q "zsh-autosuggestions" ~/.zshrc; then
    sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
    log "Updated plugins in .zshrc."
else
    log "Plugins already configured in .zshrc."
fi

# Add greeting based on time of day to .zshrc

# Ensure a custom greeting is only added once to .zshrc
GREETING_LINE='hours=$(date +%H)'
if ! grep -Fxq "$GREETING_LINE" ~/.zshrc; then
    echo "$GREETING_LINE" >> ~/.zshrc
    echo 'if [[ $hours -lt 12 ]]' >> ~/.zshrc
    echo 'then' >> ~/.zshrc
    echo '  st="Morning"' >> ~/.zshrc
    echo 'elif [[ $hours -gt 11 ]] && [[ $hours -lt 17 ]]' >> ~/.zshrc
    echo 'then' >> ~/.zshrc
    echo '  st="Afternoon"' >> ~/.zshrc
    echo 'else' >> ~/.zshrc
    echo '  st="Evening"' >> ~/.zshrc
    echo 'fi' >> ~/.zshrc
    echo "" >> ~/.zshrc
    echo 'echo "Hello Dulan, Good $st"' >> ~/.zshrc
fi

# install git fuzzy - https://github.com/bigH/git-fuzzy.git, addd if not already installed
if [ ! -d "$HOME/git-fuzzy" ]; then
    log "Installing git fuzzy..."
    git clone https://github.com/bigH/git-fuzzy.git
    # add the executable to your path
    echo "export PATH=\"$(pwd)/git-fuzzy/bin:\$PATH\"" >> ~/.zshrc
    echo "alias fg='git-fuzzy'" >> ~/.zshrc
else
    log "git fuzzy already installed. Skipping."
fi

# Apply changes
log "Applying changes..."
zsh -c "source ~/.zshrc"

log "Oh My Zsh installation completed with autosuggestions and syntax highlighting enabled!"