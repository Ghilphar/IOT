#!/bin/bash

# waiting for eth1 to be configured
while true; do
    IP=$(ip addr show eth1 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)
    if [[ "$IP" == "192.168.56.111" ]]; then
        break
    fi
    echo "Waiting for eth1 to be configured..."
    sleep 2
done

# Ensure the token is present
while true; do
    if [[ -f "/vagrant/token" ]]; then
        break
    fi
    echo "Waiting for k3s token from master..."
    sleep 2
done

# Read the token
TOKEN=$(cat /vagrant/token)

# Join the k3s cluster
#The K3s server needs port 6443 to be accessible by all nodes.
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=$TOKEN sh -
