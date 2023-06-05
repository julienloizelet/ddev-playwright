#ddev-generated
# Remove the line above if you don't want this file to be overwritten when you run
# ddev get julienloizelet/ddev-playwright
#
# This file comes from https://github.com/julienloizelet/ddev-playwright
#
FROM mcr.microsoft.com/playwright:focal

# CAROOT for `mkcert` to use, has the CA config
ENV CAROOT=/mnt/ddev-global-cache/mkcert

# Install the correct architecture binary of `mkcert`
RUN export TARGETPLATFORM=linux/$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/') && mkdir -p /usr/local/bin && curl --fail -JL -s -o /usr/local/bin/mkcert "https://dl.filippo.io/mkcert/latest?for=${TARGETPLATFORM}"
RUN chmod +x /usr/local/bin/mkcert


# Debian images by default disable apt caching, so turn it on until we finish
# the build.
RUN mv /etc/apt/apt.conf.d/docker-clean /etc/apt/docker-clean-disabled

# Install a window manager.
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
      --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update \
    && apt-get install -y icewm xauth

# Install kasmvnc for remote access.
RUN /bin/bash -c 'if [ $(arch) == "aarch64" ]; then KASM_ARCH=arm64; else KASM_ARCH=amd64; fi; wget https://github.com/kasmtech/KasmVNC/releases/download/v1.1.0/kasmvncserver_bullseye_1.1.0_${KASM_ARCH}.deb'
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
      --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get install -y ./kasmvncserver*.deb

# We can't add the user to the ssl-cert group. Rather, we can add them, but it
# won't actually apply to ddev ssh / docker exec.
# Even though we disable requiring SSL because we route through the ddev
# router, kasmvnc still requires reading the TLS cert.
#RUN sudo chgrp -R $gid /etc/ssl/private

RUN mkdir /root/.vnc
COPY kasmvnc.yaml xstartup /root/.vnc
#RUN chown $username:$username /home/$username/.vnc/*
RUN touch /root/.vnc/.de-was-selected

RUN /bin/bash -c 'echo -e "secret\nsecret\n" | kasmvncpasswd -wo -u root'

# We're done with apt so disable caching again for the final image.
RUN mv /etc/apt/docker-clean-disabled /etc/apt/apt.conf.d/docker-clean
