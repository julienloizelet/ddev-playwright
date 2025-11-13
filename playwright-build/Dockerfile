#ddev-generated
# Remove the line above if you don't want this file to be overwritten when you run
# ddev add-on get julienloizelet/ddev-playwright
#
# This file comes from https://github.com/julienloizelet/ddev-playwright
#
ARG PLAYWRIGHT_DOCKER_IMAGE=mcr.microsoft.com/playwright:focal
FROM ${PLAYWRIGHT_DOCKER_IMAGE}

ARG PLAYWRIGHT_DOCKER_IMAGE
LABEL PARENT_IMAGE="${PLAYWRIGHT_DOCKER_IMAGE}"

# Debian images by default disable apt caching, so turn it on until we finish
# the build.
RUN mv /etc/apt/apt.conf.d/docker-clean /etc/apt/docker-clean-disabled

ARG uid
ARG gid
RUN usermod -u "$uid" pwuser
RUN groupmod -g "$gid" pwuser

# Define CAROOT for mkcert
ENV CAROOT=/mnt/ddev-global-cache/mkcert

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
      --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update \
    && apt-get install -y sudo

# Allow the `pwuser` user passwordless sudo for `mkcert -install`
RUN mkdir -p /etc/sudoers.d && \
    echo "pwuser ALL=(ALL) NOPASSWD: ALL" > "/etc/sudoers.d/pwuser" && \
    chmod 0440 "/etc/sudoers.d/pwuser"

# Install mkcert for the correct architecture
ARG TARGETARCH
RUN mkdir -p /usr/local/bin && \
    curl --fail -JL -s -o /usr/local/bin/mkcert "https://dl.filippo.io/mkcert/latest?for=linux/${TARGETARCH}" && \
    chmod +x /usr/local/bin/mkcert

# Install a window manager.
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
      --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update \
    && apt-get install -y icewm xauth

# Install KasmVNC for remote access.
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
      --mount=type=cache,target=/var/lib/apt,sharing=locked \
    wget https://github.com/kasmtech/KasmVNC/releases/download/v1.1.0/kasmvncserver_bullseye_1.1.0_${TARGETARCH}.deb && \
    apt-get install -y ./kasmvncserver*.deb && \
    rm -f kasmvncserver*.deb

# We're done with apt so disable caching again for the final image.
RUN mv /etc/apt/docker-clean-disabled /etc/apt/apt.conf.d/docker-clean

# Prepare KasmVNC
RUN mkdir -p /home/pwuser/.vnc
COPY kasmvnc.yaml xstartup /home/pwuser/.vnc/
RUN touch /home/pwuser/.vnc/.de-was-selected
# We actually disable auth, but KASM complains without it
RUN sudo -u pwuser /bin/bash -c 'echo -e "secret\nsecret\n" | kasmvncpasswd -wo -u pwuser'
RUN chown -R pwuser:pwuser /home/pwuser
RUN usermod -a -G ssl-cert pwuser

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
