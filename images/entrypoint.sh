#!/bin/bash
set -eux

# working dirs for the code-server.
mkdir -p /home/jovyan/work/{.config/code-oss,.vscode-oss/extensions}

jupyterhub-singleuser \
  --ServerApp.root_dir=/home/jovyan/work \
  --config=/home/jovyan/.jupyter/server_proxy_config.py \
  $@
