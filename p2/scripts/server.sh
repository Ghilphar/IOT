# eth1 is configured
# install k3s
echo 'Starting k3s installation'
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--node-ip=192.168.56.110 --flannel-iface=eth1 --write-kubeconfig-mode 644" sh -
echo 'k3s is installing'
