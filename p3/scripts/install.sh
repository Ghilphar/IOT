#!/bin/bash

# Install latest release of Docker
sudo apt autoremove -y docker.io
sudo apt install -y docker.io
sudo groupadd docker
sudo usermod -aG docker fgaribot

# install latest release of kubectl
if [ ! -f /usr/local/bin/kubectl ] ; then
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    echo 'alias k="/usr/local/bin/kubectl"' >> /home/$USER/.bashrc
    source /home/$USER/.bashrc
    rm kubectl
fi

# install latest release of k3d
if [ ! -f /usr/local/bin/k3d ] ; then
    curl -s https://raw.githubusercontent.com/rancher/k3d/main/install.sh | bash
fi
