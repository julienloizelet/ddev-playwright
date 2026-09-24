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

# Remove stale X11 lock and socket files.
# When the container was not stopped cleanly (crash, kill, host reboot), DDEV
# restarts the same container and these files survive in /tmp. KasmVNC would
# then consider display :1 taken and start Xvnc on :2, while everything else
# expects DISPLAY=:1, so the window manager would fail and the container would
# exit. Nothing else is running at this point, so removing them is safe.
rm -f /tmp/.X*-lock /tmp/.X11-unix/X*

# Start KasmVNC server
sudo -u "$(whoami)" vncserver -fg -disableBasicAuth
