#!/bin/bash

# Ensure the token is present
while true; do
    if [[ -f "/home/vagrant/token" ]]; then
        break
    fi
    echo "Waiting for k3s token from master..."
    sleep 5
done

# Read the token
TOKEN=$(cat /home/vagrant/token)

# Join the k3s cluster
curl -sfL https://get.k3s.io | K3S_URL=https://192.168.56.110:6443 K3S_TOKEN=$TOKEN sh -
