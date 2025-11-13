#!/usr/bin/env bash
#ddev-generated
# Remove the line above if you don't want this file to be overwritten when you run
# ddev add-on get julienloizelet/ddev-playwright
#
# This file comes from https://github.com/julienloizelet/ddev-playwright
#

# Install DDEV certificate
mkcert -install

# Set up homeadditions if present
if [ -d /mnt/ddev_config/.homeadditions ]; then
    cp -r /mnt/ddev_config/.homeadditions/. $HOME/
fi

# Start KasmVNC server
sudo -u pwuser vncserver -fg -disableBasicAuth
