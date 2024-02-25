#!/bin/sh
if ! which k3s &> /dev/null 2>&1; then
    sudo mkdir -p /etc/rancher/k3s/
    sudo touch /etc/rancher/k3s/kubelet.config
    sudo echo -e "apiVersion: kubelet.config.k8s.io/v1beta1\nkind: KubeletConfiguration\nshutdownGracePeriod: 30s\nshutdownGracePeriodCriticalPods: 10s" > /etc/rancher/k3s/kubelet.config
    curl -sfL https://get.k3s.io | sh -s - server --write-kubeconfig-mode '0644' --tls-san 192.168.56.110 --disable 'local-path' --kube-controller-manager-arg 'bind-address=0.0.0.0' --kube-proxy-arg 'metrics-bind-address=0.0.0.0' --kube-scheduler-arg 'bind-address=0.0.0.0' --kubelet-arg 'config=/etc/rancher/k3s/kubelet.config' --kube-controller-manager-arg 'terminated-pod-gc-threshold=10' --node-external-ip='192.168.56.110'
fi


kubectl apply -f /vagrant/confs/yamls/app1/app1-deployment.yaml
kubectl apply -f /vagrant/confs/yamls/app1/app1-service.yaml
kubectl apply -f /vagrant/confs/yamls/app1/app1-ingress.yaml

kubectl apply -f /vagrant/confs/yamls/app2/app2-deployment.yaml
kubectl apply -f /vagrant/confs/yamls/app2/app2-service.yaml
kubectl apply -f /vagrant/confs/yamls/app2/app2-ingress.yaml

kubectl apply -f /vagrant/confs/yamls/app3/app3-deployment.yaml
kubectl apply -f /vagrant/confs/yamls/app3/app3-service.yaml
kubectl apply -f /vagrant/confs/yamls/app3/app3-ingress.yaml



#run script to protect the running apps.
sh /vagrant/scripts/script.sh
