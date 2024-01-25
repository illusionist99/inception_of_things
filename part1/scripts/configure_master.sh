#!/bin/sh


sudo mkdir -p /etc/rancher/k3s/
sudo touch /etc/rancher/k3s/kubelet.config

echo -e "apiVersion: kubelet.config.k8s.io/v1beta1\nkind: KubeletConfiguration\nshutdownGracePeriod: 30s\nshutdownGracePeriodCriticalPods: 10s" > /etc/rancher/k3s/kubelet.config


token=`cat /vagrant/confs/cluster_token`

curl -sfL https://get.k3s.io | K3S_TOKEN="$token" sh -s - server --write-kubeconfig-mode '0644' --node-taint 'node-role.kubernetes.io/master=true:NoSchedule' --disable 'servicelb' --disable 'traefik' --disable 'local-path' --kube-controller-manager-arg 'bind-address=0.0.0.0' --kube-proxy-arg 'metrics-bind-address=0.0.0.0' --kube-scheduler-arg 'bind-address=0.0.0.0' --kubelet-arg 'config=/etc/rancher/k3s/kubelet.config' --kube-controller-manager-arg 'terminated-pod-gc-threshold=10' --node-external-ip=192.168.56.110

sudo mkdir $HOME/.kube
sudo cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/.

