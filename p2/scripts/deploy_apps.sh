#!/bin/bash

#kubectl create namespace iot 
kubectl apply -f /vagrant/config/app-deployments.yml
kubectl apply -f /vagrant/config/app-services.yml
kubectl apply -f /vagrant/config/app-ingress.yml