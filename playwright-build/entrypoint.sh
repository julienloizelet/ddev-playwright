#!/bin/bash
#ddev-generated
# Remove the line above if you don't want this file to be overwritten when you run
# ddev get julienloizelet/ddev-playwright
#
# This file comes from https://github.com/julienloizelet/ddev-playwright
#

# Change pwuser IDs to the host IDs supplied by DDEV
usermod -u "${DDEV_UID}" pwuser
groupmod -g "${DDEV_GID}" pwuser
usermod -a -G ssl-cert pwuser

# Install DDEV certificate
mkcert -install

# Set up homeadditions if present
if [ -d /mnt/ddev_config/.homeadditions ]; then
    # Since we already modified UID/GID, the -p option preserves the correct permissions
    cp -pr /mnt/ddev_config/.homeadditions/. /home/pwuser/
fi

# Run CMD from parameters as pwuser
sudo -u pwuser vncserver -fg -disableBasicAuth
