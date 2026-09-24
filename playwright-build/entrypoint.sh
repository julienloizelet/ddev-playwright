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

# Stop Xvnc cleanly when the container is stopped, so that its lock, socket and
# pid files are removed.
stop_vnc() {
    sudo -u "$(whoami)" vncserver -kill :1
    exit 0
}
trap stop_vnc TERM INT

# Start KasmVNC server on display :1.
# Xvnc and the applications of xstartup are started in the background, then
# vncserver returns. Requesting :1 explicitly makes vncserver fail if that
# display is not available, instead of silently using another one.
# sudo does not change the user here, but it re-initializes the supplementary
# groups (ssl-cert, tty) that Docker drops when the container is started with
# "user: uid:gid". vncserver refuses to start when it cannot read the KasmVNC
# certificate key, which belongs to the ssl-cert group.
sudo -u "$(whoami)" vncserver :1 -disableBasicAuth || exit 1

# Keep the container alive as long as Xvnc runs.
# The lifetime of the container is bound to Xvnc, not to the window manager
# started by xstartup: if the window manager fails, headless tests keep working.
XVNC_PID=$(cat "$HOME/.vnc/$(uname -n):1.pid")
while kill -0 "$XVNC_PID" 2>/dev/null; do
    sleep 1
done
echo "Xvnc (PID $XVNC_PID) exited, stopping the container" >&2
exit 1
