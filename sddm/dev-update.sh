#!/bin/bash

# Development script to update SDDM theme files
# Usage: ./dev-update.sh

echo "Updating SDDM theme files..."

# Copy theme files to SDDM directory
sudo cp -r theme/* /usr/share/sddm/themes/stray/

# Set proper permissions
sudo chown -R root:root /usr/share/sddm/themes/stray/
sudo chmod -R 755 /usr/share/sddm/themes/stray/

echo "Theme files updated successfully!"
echo "Restart SDDM or log out to see changes." 