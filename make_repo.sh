#!/bin/bash

# Repo Generation Script for EpiTroll

REPO_DIR="."
DEB_FILE="epitroll.deb"

if [ ! -f "$DEB_FILE" ]; then
    echo "Error: $DEB_FILE not found. Please build it first."
    exit 1
fi

echo "Updating repository metadata..."

# Generate Packages file
dpkg-scanpackages . /dev/null > Packages
gzip -fk Packages

# Generate Release file with Date and Hashes
Date=$(date -Ru)
{
    echo "Origin: EpiTroll Repository"
    echo "Label: EpiTroll"
    echo "Suite: stable"
    echo "Codename: stable"
    echo "Date: $Date"
    echo "Architectures: all"
    echo "Components: main"
    echo "Description: Student punishment tool repository"
    echo "MD5Sum:"
    printf " $(md5sum Packages | cut -d' ' -f1) %16d Packages\n" $(stat -c%s Packages)
    printf " $(md5sum Packages.gz | cut -d' ' -f1) %16d Packages.gz\n" $(stat -c%s Packages.gz)
    echo "SHA256:"
    printf " $(sha256sum Packages | cut -d' ' -f1) %16d Packages\n" $(stat -c%s Packages)
    printf " $(sha256sum Packages.gz | cut -d' ' -f1) %16d Packages.gz\n" $(stat -c%s Packages.gz)
} > Release

echo "Done!"
