#!/bin/sh

# create 2 worker nodes
k3d cluster create my-cluster --api-port 6443 -p 8080:80@loadbalancer


# install argoCD
kubectl create namespace argocd
kubectl apply -n argocd -f install.yaml


while [ "$(kubectl get pods -n argocd -o jsonpath='{.items[*].status.containerStatuses[0].ready}')" != "true true true true true true true" ]; do
   sleep 5
   echo "\rWaiting for argoCD Pods to be ready..."
done

#kubectl wait -f install.yaml

kubectl port-forward svc/argocd-server -n argocd 8080:443 &
echo "Forwarded ArgoCD [+]"
# change argoCD admin password
#kubectl -n argocd patch secret argocd-secret -p '{"stringData":  {
#    "admin.password": "$2a$12$XMIS1Jr/SV3y8Iffy/EAteitmV/MwDqkBm5utrfDuc73Op8JZSf6a",
#    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
#}}'
