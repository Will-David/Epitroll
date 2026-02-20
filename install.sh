#!/bin/bash

# Installer for EpiTroll

if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (sudo ./install.sh)"
    exit 1
fi

DEST="/usr/local/bin/punish"
SUDOERS_FILE="/etc/sudoers.d/epitroll"

echo "Installing punish script to $DEST..."
cp punish.sh "$DEST"
chmod +x "$DEST"

echo "Configuring password-less execution..."
echo "ALL ALL=(ALL) NOPASSWD: $DEST" > "$SUDOERS_FILE"
chmod 0440 "$SUDOERS_FILE"

# Optional: install 'sl' if missing
if ! command -v sl &> /dev/null; then
    echo "Installing 'sl' for maximum troll effect..."
    apt-get update && apt-get install -y sl
fi

echo "EpiTroll installed successfully!"
echo "Usage: sudo punish [FLAGS]"
