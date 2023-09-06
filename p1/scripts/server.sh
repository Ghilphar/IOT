# !/bin/bash

# waiting for eth1 to be configured
while true; do
    IP=$(ip addr show eth1 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1)
    if [[ "$IP" == "192.168.56.110" ]]; then
        break
    fi
    echo "Waiting for eth1 to be configured..."
    sleep 5
done

# eth1 is configured
# install k3s
echo 'Starting k3s installation'
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=192.168.56.110 --flannel-iface=eth1 --write-kubeconfig-mode 644" sh -
echo 'k3s is installing'


# Ensure the token is present
token_created=false

# add token to shared folder
for i in {1..20}; do
    if [ -f /var/lib/rancher/k3s/server/node-token ]; then
        echo 'k3s token is created'
        sudo cat /var/lib/rancher/k3s/server/node-token > /vagrant/token
        token_created=true
        break
    fi
    sleep 2
done

if [ "$token_created" = false ]; then
    echo 'Error: k3s token was not created within the expected time.'
fi
