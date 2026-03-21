#!/bin/bash

set -e

echo "=== WSL2 Docker DNS Fix ==="

echo "[1/4] Writing /etc/wsl.conf to disable auto DNS generation..."
sudo tee /etc/wsl.conf << 'WSLCONF'
[network]
generateResolvConf = false
WSLCONF

echo "[2/4] Unlinking auto-generated resolv.conf..."
sudo unlink /etc/resolv.conf 2>/dev/null || echo "  (already unlinked, skipping)"

echo "[3/4] Writing new resolv.conf with Google DNS..."
sudo tee /etc/resolv.conf << 'RESOLVCONF'
nameserver 8.8.8.8
nameserver 8.8.4.4
RESOLVCONF

echo "[4/4] Restarting Docker..."
sudo systemctl restart docker

echo ""
echo "=== Verifying DNS ==="
dig +short A auth.docker.io
dig +short A registry-1.docker.io

echo ""
echo "=== Testing Docker ==="
docker pull hello-world

echo ""
echo "Done! If docker pull succeeded, the fix worked."