#!/bin/bash
#ddev-generated
# Remove the line above if you don't want this file to be overwritten when you run
# ddev get julienloizelet/ddev-playwright
#
# This file comes from https://github.com/julienloizelet/ddev-playwright
#

# Change pwuser IDs to the host IDs supplied by DDEV
sudo usermod -u ${DDEV_UID} pwuser
sudo groupmod -g ${DDEV_GID} pwuser
sudo chgrp -R ${DDEV_GID}  /etc/ssl/private

# Install DDEV certificate
mkcert -install

# Switch to pwuser which now should have the same file system permissions as the host user
su - pwuser

# Run CMD from parameters
"$@"
