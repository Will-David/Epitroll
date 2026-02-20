#!/bin/bash

# Repo Generation Script for EpiTroll

REPO_DIR="repo"
DEB_FILE="epitroll.deb"

if [ ! -f "$DEB_FILE" ]; then
    echo "Error: $DEB_FILE not found. Please build it first."
    exit 1
fi

echo "Creating repository structure..."
mkdir -p "$REPO_DIR"

# Move the deb to the repo folder
cp "$DEB_FILE" "$REPO_DIR/"

# Generate Packages file
cd "$REPO_DIR"
dpkg-scanpackages . /dev/null > Packages
gzip -fk Packages

# Generate Release file
cat <<EOF > Release
Origin: EpiTroll Repository
Label: EpiTroll
Suite: stable
Codename: stable
Architectures: all
Components: main
Description: Student punishment tool repository
EOF

echo "Done! You can now host the '$REPO_DIR' directory on GitHub Pages."
echo "To use this repo on another machine:"
echo "echo \"deb [trusted=yes] https://your-username.github.io/your-repo-name ./\" | sudo tee /etc/apt/sources.list.d/epitroll.list"
echo "sudo apt update && sudo apt install epitroll"
