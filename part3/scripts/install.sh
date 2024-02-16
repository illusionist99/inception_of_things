#!/bin/bash


sudo apt update
sudo apt upgrade -y 

if ! command -v docker 1>/dev/null; then 
    echo "installing docker "
    sudo apt-get install -y ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    sudo echo "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install docker-ce docker-ce-cli containerd.io docker-compose -y
    sudo usermod -aG docker $USER
else
    echo "docker is already installed"
fi

if ! command -v k3d 1>/dev/null; then
    echo "installing k3d"
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
    sudo apt update
else
    echo "k3d is already installed"
fi

if ! command -v kubectl 1>/dev/null ; then 
    echo "installing kubectl"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    sudo apt update
else
    echo "kubectl is already installed"
fi

echo "all dependencies are installed successfully"
