#!/bin/bash

set -e

KEY_PATH="$HOME/.ssh/id_ed25519"
EMAIL="dulanjayasuriya@gmail.com"

echo "=== SSH Key Setup ==="
echo ""
echo "Choose an option:"
echo "  1) Generate new SSH keys"
echo "  2) Replace existing keys with provided values"
read -p "Enter choice [1/2]: " choice

mkdir -p ~/.ssh
chmod 700 ~/.ssh

if [ "$choice" == "1" ]; then
    echo ""
    echo "[1/3] Generating new ed25519 SSH key pair..."
    ssh-keygen -t ed25519 -C "$EMAIL" -f "$KEY_PATH"

elif [ "$choice" == "2" ]; then
    echo ""
    echo "Paste your private key below."
    echo "When done, enter a new line with just: END"
    echo "---"
    private_key=""
    while IFS= read -r line; do
        [ "$line" == "END" ] && break
        private_key+="$line"$'\n'
    done

    read -p "Enter the public key (single line): " public_key

    if [ -z "$private_key" ] || [ -z "$public_key" ]; then
        echo "Error: Both keys are required."
        exit 1
    fi

    echo ""
    echo "[1/3] Writing keys to $KEY_PATH ..."
    echo "$private_key" > "$KEY_PATH"
    echo "$public_key" > "${KEY_PATH}.pub"

else
    echo "Invalid choice. Exiting."
    exit 1
fi

echo "[2/3] Setting correct permissions..."
chmod 600 "$KEY_PATH"
chmod 644 "${KEY_PATH}.pub"

echo "[3/3] Adding key to ssh-agent..."
eval "$(ssh-agent -s)"
ssh-add "$KEY_PATH"

echo ""
echo "=== Done! ==="
echo ""
echo "Your public key (add this to GitHub/GitLab/etc.):"
echo "---"
cat "${KEY_PATH}.pub"[]