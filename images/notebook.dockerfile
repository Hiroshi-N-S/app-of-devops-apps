# docker build --no-cache -t mysticstorage.local:8443/notebook/jupyter:lab-4.0.2 -f notebook.dockerfile .

# --- --- --- --- --- --- --- --- ---
# deno builder image.
#
FROM rust:1.75.0-bookworm AS builder

ENV DENO_VER=1.41.3
ENV CARGO_TARGET_DIR=/root/target

WORKDIR /root
RUN set -eux ;\
      apt update && apt install -y \
        cmake \
        protobuf-compiler \
        libssl-dev \
        pkg-config \
        build-essential \
      ;\
      # --- --- --- --- --- --- --- --- ---
      # build deno for TypeScript runtime.
      # --- --- --- --- --- --- --- --- ---
      cargo install deno@${DENO_VER} --locked

# --- --- --- --- --- --- --- --- ---
# notebook image.
#
FROM python:3.12.3-bookworm

ARG TARGETARCH

ARG USERNAME=jovyan
ARG GROUPNAME=jovyan
ARG UID=1000
ARG GID=1000

ENV JUPYTER_VER=4.0.2
ENV JUPYTER_SERVER_PROXY_VER=4.1.2
ENV CODE_SERVER_VER=4.23.1
ENV NODE_RED_VER=3.1.9

ENV GO_VERSION=go1.21.5

ENV DEBIAN_FRONTEND=noninteractive

ENV http_proxy=
ENV https_proxy=
ENV no_proxy=

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

USER root
WORKDIR /root
RUN set -eux ;\
      apt update && apt install -y \
        locales \
        sudo \
      ;\
      # change default locale
      echo 'LANG=en_US LC_ALL=en_US.UTF-8' > /etc/default/locale ;\
      echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen ;\
      locale-gen ;\
      # add a user.
      groupadd -g ${GID} ${GROUPNAME} ;\
      useradd -m -s /bin/bash -u ${UID} -g ${GID} ${USERNAME} ;\
      # add the user to sudoers.
      echo "${USERNAME} ALL=(ALL:ALL) NOPASSWD:ALL" >> user ;\
      mkdir -p /etc/sudoers.d ;\
      mv user /etc/sudoers.d

ENV PATH=$PATH:/home/${USERNAME}/.local/bin

USER ${USERNAME}
WORKDIR /home/${USERNAME}
RUN set -eux ;\
      # --- --- --- --- --- --- --- --- ---
      # install Jupyter.
      # --- --- --- --- --- --- --- --- ---
      pip install --upgrade pip ;\
      pip install \
        jupyterlab==${JUPYTER_VER} \
        jupyterhub==${JUPYTER_VER} \
        jupyter-server-proxy==${JUPYTER_SERVER_PROXY_VER} \
      ;\
      # clean cache
      rm -rf ~/.cache

COPY --chown=${UID}:${GID} --chmod=644 entrypoint.sh /home/${USERNAME}/
COPY --chown=${UID}:${GID} --chmod=644 server_proxy_config.py /home/${USERNAME}/.jupyter/
ENV PATH=$PATH:/home/${USERNAME}/node_modules/.bin
RUN set -eux ;\
      # --- --- --- --- --- --- --- --- ---
      # install nodejs and npm.
      # --- --- --- --- --- --- --- --- ---
      curl -fsSL https://deb.nodesource.com/setup_18.x | sudo bash - ;\
      sudo apt update && sudo apt install -y \
        nodejs \
      ;\
      npm config set prefix '~/.local/' ;\
      # --- --- --- --- --- --- --- --- ---
      # install code-server.
      # --- --- --- --- --- --- --- --- ---
      # ref: https://coder.com/docs/code-server/latest/install#npm
      npm install --unsafe-perm code-server@${CODE_SERVER_VER} ;\
      sudo mkdir -p /etc/code-server ;\
      sudo chown ${UID}:${GID} /etc/code-server ;\
      # get icons
      wget https://code.visualstudio.com/assets/branding/visual-studio-code-icons.zip ;\
      unzip visual-studio-code-icons.zip -d /etc/code-server/ ;\
      rm -rf visual-studio-code-icons.zip ;\
      # --- --- --- --- --- --- --- --- ---
      # install Node-RED.
      # --- --- --- --- --- --- --- --- ---
      npm install --unsafe-perm node-red@${NODE_RED_VER} ;\
      # clean cache
      rm -rf ~/.cache

ENV PATH=$PATH:/usr/local/go/bin:/home/${USERNAME}/go/bin
RUN set -eux ;\
      # --- --- --- --- --- --- --- --- ---
      # install Go.
      # --- --- --- --- --- --- --- --- ---
      wget https://go.dev/dl/${GO_VERSION}.linux-${TARGETARCH}.tar.gz ;\
      sudo tar -C /usr/local -xzf ${GO_VERSION}.linux-${TARGETARCH}.tar.gz ;\
      rm ${GO_VERSION}.linux-${TARGETARCH}.tar.gz ;\
      # --- --- --- --- --- --- --- --- ---
      # install Go Kernel.
      # --- --- --- --- --- --- --- --- ---
      go install github.com/janpfeifer/gonb@latest ;\
      go install golang.org/x/tools/cmd/goimports@latest ;\
      go install golang.org/x/tools/gopls@latest ;\
      gonb --install ;\
      # clean cache
      rm -rf /home/${USERNAME}/.cache

RUN set -eux ;\
      # --- --- --- --- --- --- --- --- ---
      # install Rust and Rust Kernel.
      # --- --- --- --- --- --- --- --- ---
      curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y ;\
      . /home/jovyan/.cargo/env ;\
      cargo install evcxr_jupyter ;\
      evcxr_jupyter --install

COPY --from=builder /usr/local/cargo/bin/deno /usr/local/bin/deno
RUN set -eux ;\
      # --- --- --- --- --- --- --- --- ---
      # install Deno Kernel for TypeScript.
      # --- --- --- --- --- --- --- --- ---
      deno jupyter --install
