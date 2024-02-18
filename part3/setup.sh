#!/bin/sh

# create cluster
k3d cluster create my-cluster --no-lb --k3s-arg="--disable=traefik@server:0"


# install argoCD
kubectl create namespace argocd
kubectl apply -n argocd -f install.yaml

# waiting for pods to be ready

while [ "$(kubectl get pods -n argocd -o jsonpath='{.items[*].status.containerStatuses[0].ready}')" != "true true true true true true true" ]; do
   sleep 5
   echo "\rWaiting for argoCD Pods to be ready..."
done

#kubectl wait -f install.yaml
#kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
# forwarding service to localhost 443
kubectl port-forward svc/argocd-server -n argocd 8080:443 &
echo "Forwarded ArgoCD [+]"


# change argoCD admin password admin00
kubectl -n argocd patch secret argocd-secret -p '{"stringData":  {
    "admin.password": "$2a$10$4JUycXXGVgWmlZlCyGL84OYs1FvnXWGSHovmTTizeiiKOIG6Ig1aK",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
}}'


#-----------------DEPLOY--APP-------------------#

kubectl create namespace dev
kubectl config set-context --current --namespace=argocd

argocd login localhost:8080 --username admin --password admin00 --insecure

argocd app create app --repo https://github.com/illusionist99/app_config.git --path wil-playground  --dest-namespace dev --dest-server https://kubernetes.default.svc --directory-recurse  --sync-policy automated --auto-prune --upsert

argocd app get app

argocd app sync app

