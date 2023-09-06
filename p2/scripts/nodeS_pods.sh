#!/bin/bash

while true; do
    IP=$(ip addr show eth1 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)
    if [[ "$IP" == "192.168.56.110" ]]; then
        break
    fi
    echo "Waiting for eth1 to be configured..."
    sleep 5
done

curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=192.168.56.110 --flannel-iface=eth1 --write-kubeconfig-mode 644" sh -

# Ensure kubectl is in the PATH for future scripts
#export PATH=$PATH:/usr/local/bin
# Allow vagrant user to access kubectl
#cp /etc/rancher/k3s/k3s.yaml /home/vagrant/
#chown vagrant:vagrant /home/vagrant/k3s.yaml
#export KUBECONFIG=/home/vagrant/k3s.yaml

# Waiting for Kubernetes API to be responsive
while ! kubectl cluster-info; do
    echo "Waiting for Kubernetes API to be responsive..."
    sleep 5
done