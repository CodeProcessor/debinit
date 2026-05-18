#!/bin/bash
set -e

# Function to print messages
log() {
    echo -e "\e[32m[k8s] $1\e[0m"
}

err() {
    echo -e "\e[31m[k8s] ERROR: $1\e[0m" >&2
    exit 1
}

# ─── kubectl ──────────────────────────────────────────────────────────────────
install_kubectl() {
    if command -v kubectl >/dev/null 2>&1; then
        log "kubectl already installed: $(kubectl version --client --short 2>/dev/null | head -1)"
        return
    fi

    log "Installing kubectl..."
    KUBECTL_VERSION="$(curl -fsSL https://dl.k8s.io/release/stable.txt)"
    curl -fsSL "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl" -o /tmp/kubectl
    chmod +x /tmp/kubectl
    sudo mv /tmp/kubectl /usr/local/bin/kubectl
    log "kubectl ${KUBECTL_VERSION} installed."
}

# ─── minikube ─────────────────────────────────────────────────────────────────
install_minikube() {
    if command -v minikube >/dev/null 2>&1; then
        log "minikube already installed: $(minikube version --short 2>/dev/null)"
        return
    fi

    log "Installing minikube..."
    curl -fsSL https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 -o /tmp/minikube
    chmod +x /tmp/minikube
    sudo mv /tmp/minikube /usr/local/bin/minikube
    log "minikube $(minikube version --short) installed."
}

# ─── k9s ──────────────────────────────────────────────────────────────────────
install_k9s() {
    if command -v k9s >/dev/null 2>&1; then
        log "k9s already installed: $(k9s version --short 2>/dev/null)"
        return
    fi

    if command -v brew >/dev/null 2>&1; then
        log "Installing k9s via Homebrew..."
        brew install k9s -q
    else
        log "Installing k9s via GitHub release..."
        K9S_VERSION="$(curl -fsSL https://api.github.com/repos/derailed/k9s/releases/latest \
            | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')"
        curl -fsSL "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz" \
            | tar -xz -C /tmp k9s
        chmod +x /tmp/k9s
        sudo mv /tmp/k9s /usr/local/bin/k9s
    fi
    log "k9s installed."
}

# ─── helm ─────────────────────────────────────────────────────────────────────
install_helm() {
    if command -v helm >/dev/null 2>&1; then
        log "helm already installed: $(helm version --short 2>/dev/null)"
        return
    fi

    if command -v brew >/dev/null 2>&1; then
        log "Installing helm via Homebrew..."
        brew install helm -q
    else
        log "Installing helm via official install script..."
        curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    fi
    log "helm installed."
}

# ─── zshrc aliases ────────────────────────────────────────────────────────────
configure_zshrc() {
    log "Configuring kubectl/k9s aliases in .zshrc..."

    ALIASES=(
        'alias k="kubectl"'
        'alias kgp="kubectl get pods"'
        'alias kgs="kubectl get svc"'
        'alias kgn="kubectl get nodes"'
        'alias kdp="kubectl describe pod"'
        'alias klogs="kubectl logs -f"'
        'alias kctx="kubectl config use-context"'
        'alias kns="kubectl config set-context --current --namespace"'
        'source <(kubectl completion zsh)'
        'source <(minikube completion zsh)'
        'source <(helm completion zsh)'
    )

    for alias_cmd in "${ALIASES[@]}"; do
        if ! grep -Fxq "$alias_cmd" ~/.zshrc 2>/dev/null; then
            echo "$alias_cmd" >> ~/.zshrc
        fi
    done

    log ".zshrc aliases configured."
}

# ─── main ─────────────────────────────────────────────────────────────────────
log "Starting Kubernetes toolchain installation..."

install_kubectl
install_minikube
install_k9s
install_helm
configure_zshrc

log "All Kubernetes tools installed. Restart your shell or run: source ~/.zshrc"
log "Start a local cluster with: minikube start"
