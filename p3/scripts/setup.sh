#!/bin/sh

# create cluster
k3d cluster create mycluster --port 8888:8888@loadbalancer

# install argoCD
kubectl create namespace argocd
kubectl apply -n argocd -f install.yaml

# waiting for pods to be ready
while [ "$(kubectl get pods -n argocd -o jsonpath='{.items[*].status.containerStatuses[0].ready}')" != "true true true true true true true" ]; do
   sleep 5
   echo "\rWaiting for argoCD Pods to be ready..."
done

# forwarding service to localhost 443
kubectl port-forward svc/argocd-server -n argocd 8080:443 &
echo "Forwarded ArgoCD [+]"


# change argoCD admin password admin00
kubectl -n argocd patch secret argocd-secret -p '{"stringData":  {
    "admin.password": "$2a$10$4JUycXXGVgWmlZlCyGL84OYs1FvnXWGSHovmTTizeiiKOIG6Ig1aK",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
}}'

#-----------------DEPLOY--APP-------------------#
# create namespace DEV

kubectl create namespace dev

# deploy app from config
kubectl apply -f project.yaml -n argocd 
kubectl apply -f application.yaml -n argocd

