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

# Waiting for Kubernetes API to be available
while ! kubectl cluster-info; do
    echo "Waiting for Kubernetes API to be available..."
    sleep 5
done
