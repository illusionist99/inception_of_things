#!/bin/sh


sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"


sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

