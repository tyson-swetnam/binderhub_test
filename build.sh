#!/bin/bash

# run file as sudo

# download and install Kubernetes
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
# adds autocompletion
echo "source <(kubectl completion bash)" >> ~/.bashrc

# Install Minikube with KVM2 driver
# https://github.com/kubernetes/minikube/blob/master/docs/drivers.md#kvm-driver

# download and install Helm
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
helm init

# BinderHub
sudo mkdir /opt/binderhub
cd /opt/binderhub
