#!/bin/bash
#ddev-generated
# Remove the line above if you don't want this file to be overwritten when you run
# ddev get julienloizelet/ddev-playwright
#
# This file comes from https://github.com/julienloizelet/ddev-playwright
#

# Change pwuser IDs to the host IDs supplied by DDEV
usermod -u ${DDEV_UID} pwuser
groupmod -g ${DDEV_GID} pwuser
usermod -a -G ssl-cert pwuser

# Install DDEV certificate
mkcert -install

# Set up .nprm rc if present. This might contain credentials for private registries
[ -f "/mnt/ddev_config/.homeadditions/.npmrc" ] && ln -s "/mnt/ddev_config/.homeadditions/.npmrc" /home/pwuser/.npmrc


# Run CMD from parameters as pwuser
sudo -u pwuser vncserver -fg -disableBasicAuth
