# debinit

```bash
curl -fsSL https://raw.githubusercontent.com/CodeProcessor/debinit/main/install.sh | bash
```

Automated development environment setup for Ubuntu/Debian systems. Transforms a fresh install into a fully-configured developer workstation with modern CLI tools and an enhanced shell — in a single command.

## What it does

- Updates system packages
- Installs essential dev tools via `apt` (git, curl, neovim, tmux, zsh, build-essential)
- Sets up **Zsh** with [Oh My Zsh](https://ohmyz.sh/), the `candy` theme, and plugins:
  - `zsh-autosuggestions`
  - `zsh-syntax-highlighting`
  - `git-fuzzy`
- Installs **Homebrew** (Linux) and a curated set of modern CLI tools:
  - [`eza`](https://github.com/eza-community/eza) — modern `ls` replacement (with Dracula theme)
  - [`bat`](https://github.com/sharkdp/bat) — `cat` with syntax highlighting
  - [`fzf`](https://github.com/junegunn/fzf) — fuzzy finder
  - [`zoxide`](https://github.com/ajeetdsouza/zoxide) — smarter `cd`
  - [`atuin`](https://github.com/atuinsh/atuin) — shell history search
  - [`ripgrep`](https://github.com/BurntSushi/ripgrep) — fast file search
  - [`ranger`](https://ranger.github.io/) — terminal file manager
  - [`btop`](https://github.com/aristocratsft/btop) / `htop` — system monitors
  - `tldr`, `nerdfetch`, `gcc`

Shell aliases are configured automatically (`vi`→`nvim`, `ls`→`eza`, `cat`→`bat`, etc.)

## Requirements

- Ubuntu / Debian-based Linux
- `sudo` access
- Internet connection

## Usage

### Quick start

```bash
# Install just (task runner)
curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | sudo bash -s -- --to /usr/local/bin

# Run full setup
just all
```

### Individual tasks

```bash
just update          # Update & upgrade system packages
just shell           # APT packages + Zsh + Oh My Zsh
just brew            # Homebrew + CLI tools
just enable_ssh_server  # Install & configure OpenSSH
just clean           # Remove Docker images older than 30 days
```

See all available commands:

```bash
just --list
```

### Test in Docker

```bash
just test      # Build image and launch a test container
just stop-test # Stop the test container
```

Or manually:

```bash
docker build -t debinit --network=host .
docker run -it --rm --name debinit-test debinit
```

The Docker image is based on **Ubuntu 24.04** and runs as a non-root `developer` user with passwordless sudo.

## Project structure

```
debinit/
├── Justfile                        # Task definitions
├── Dockerfile                      # Container for testing
└── scripts/
    ├── updates.sh                  # System update
    ├── apt-install-packages.sh     # Core APT packages
    ├── install-oh-my-zsh.sh        # Zsh + Oh My Zsh setup
    ├── brew-install-packages.sh    # Homebrew + CLI tools
    ├── enable-ssh.sh               # SSH server configuration
    ├── install-docker-ce.sh        # Docker CE installation
    └── clean_docker_images.sh      # Docker image cleanup
```

## Optional: SSH & Docker

Enable SSH access:

```bash
just enable_ssh_server
```

Install Docker CE:

```bash
./scripts/install-docker-ce.sh
```

## License

MIT
