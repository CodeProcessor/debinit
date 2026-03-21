
[private]
default:
	just --list

# Default action
all: exec shell brew

exec:
	@echo "Adding permissions..."
	sudo chmod +x scripts/*.sh

# Update system
update:
	#!/bin/bash
	@echo "Updating system..."
	./scripts/updates.sh

# Install essential packages
shell:exec
	#!/bin/bash
	echo "Installing APT packages and setup ohmyzsh..."
	./scripts/apt-install-packages.sh
	./scripts/install-oh-my-zsh.sh

brew:exec
	echo "Installing Brew packages..."
	./scripts/brew-install-packages.sh
	zsh

docker:exec
	echo "Installing Docker..."
	./scripts/install-docker-ce.sh
	docker --version
	docker compose --version

	
enable_ssh_server:exec
	@echo "Enabling SSH server..."
	./scripts/enable-ssh-server.sh
	
# Configure dotfiles and custom setup
config:exec
	@echo "Configuring dotfiles..."
	./scripts/configure-dotfiles.sh

# Clean up system
clean:exec
	@echo "Cleaning up..."
	./scripts/clean_docker_images.sh

# test this using docker file
test:
	@echo "Testing..."
	docker build -t debian-init --network=host .
	docker run -it --rm --name debian-init-test debian-init

stop-test:
	docker stop debian-init-test 

# Display help
help:
	@echo "Makefile commands:"
	@echo "  make update     Update and upgrade the system"
	@echo "  make install    Install essential packages"
	@echo "  make config     Configure dotfiles and custom settings"
	@echo "  make clean      Remove unused packages and cache"
	@echo "  make all        Run update, install, and config"
