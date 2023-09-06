#!/bin/bash

# Ensure kubectl is in the PATH
# export PATH=$PATH:/usr/local/bin
# export KUBECONFIG=/home/vagrant/k3s.yaml

kubectl apply -f /vagrant/config/app-deployments.yml
kubectl apply -f /vagrant/config/app-services.yml
kubectl apply -f /vagrant/config/app-ingress.yml