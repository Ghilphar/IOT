echo run 'kubectl get pods -Aw' to see the status of the pods
echo go to localhost:8080/argocd to see the ArgoCD UI
echo go to localhost:8888 to see wil s application
echo login with admin and use the following password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
sleep 3
echo to prove the synchronization change the deployment image version in https://github.com/Ghilphar/IOT_p3
echo do not forget to reforward the port after resyncing the repo
kubectl port-forward svc/wil-app-service -n dev 8888:8888
