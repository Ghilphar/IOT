#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
# set -e

#echo ">>> Creating a Kubernetes cluster with k3d"
if k3d cluster list | grep -q 'p3'; then
    echo ">>> Cluster 'p3' already exists. Using existing cluster."
else
    echo ">>> Creating a Kubernetes cluster with k3d"
    # create cluster p3
    k3d cluster create p3 \
      --api-port 6443 \
      --servers 1 \
      --agents 2 \
      --port 8080:80@loadbalancer \
      --port 8443:443@loadbalancer \
      --wait \
      --verbose
fi
# expose services on localhost (port 8080 for HTTP and 8443 for HTTPS)


# wait for cluster to be ready
echo ">>> Waiting for Traefik (Ingress controller) to set up"
# Wait for Traefik related jobs to complete (with a maximum of 5 minutes timeout)
kubectl -n kube-system wait --for=condition=complete --timeout=5m jobs/helm-install-traefik-crd
kubectl -n kube-system wait --for=condition=complete --timeout=5m jobs/helm-install-traefik
kubectl get jobs -n kube-system

echo ">>> Setting up namespaces"
# Check if argocd namespace exists
if ! kubectl get namespace argocd > /dev/null 2>&1; then
  kubectl create namespace argocd
fi

# Check if dev namespace exists
if ! kubectl get namespace dev > /dev/null 2>&1; then
  kubectl create namespace dev
fi

echo ">>> Installing ArgoCD"
#kubectl apply -f ../config/install_argocd.yaml -n argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
# waiting for all pods to be ready
kubectl wait --for=condition=Ready --timeout=5m pods --all -n argocd

kubectl apply -f ../config/ingress_argocd.yaml -n argocd
# check ArgoCD installation status
kubectl rollout status deployment argocd-server -n argocd
kubectl rollout status deployment argocd-redis -n argocd
kubectl rollout status deployment argocd-repo-server -n argocd
kubectl rollout status deployment argocd-dex-server -n argocd

echo ">>> Setting up ArgoCD CLI"
# set up argocd CLI
# binary is moved to /usr/local/bin to be globally accessible
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
# rm argocd-linux-amd64 as it is no longer needed
rm argocd-linux-amd64

echo ">>> Fetching the ArgoCD admin password"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo

echo ">>> Applying ArgoCD projects and applications"
kubectl apply -f ../config/add_project_to_argo.yaml -n argocd
kubectl apply -f ../config/add_application_to_argo.yaml -n argocd
kubectl wait --for=condition=Ready --timeout=5m pods --all -n argocd

echo ">>> Script execution completed"
