#!/bin/bash

# Install latest release of Docker
sudo apt autoremove -y docker.io
sudo apt install -y docker.io
sudo groupadd docker
sudo usermod -aG docker fgaribot

# install latest release of k3d
if [ ! -f /usr/local/bin/k3d ] ; then
    curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
fi
