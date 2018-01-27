#!/bin/bash

# https://www.techrepublic.com/article/how-to-quickly-install-kubernetes-on-ubuntu/

sudo apt-get update && apt-get install -y apt-transport-https

sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add 

sudo touch /etc/apt/sources.list.d/kubernetes.list 
sudo su
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main"  >> /etc/apt/sources.list.d/kubernetes.list 
exit

# adds autocompletion
echo "source <(kubectl completion bash)" >> ~/.bashrc

# download and install Kubernetes

sudo apt-get update --allow-unauthenticated
sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni 

# Start a Kubernetes Cluster
sudo kubeadm init
# create a home profile config
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# download and install Helm
# force remove helm: helm reset --force
wget https://storage.googleapis.com/kubernetes-helm/helm-v2.7.2-linux-amd64.tar.gz
tar -zxvf helm-v2.7.2-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm

# Install latest version - there was a problem with Tiller using this version.
#curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

# https://media.readthedocs.org/pdf/zero-to-jupyterhub-with-kubernetes/stable/zero-to-jupyterhub-with-kubernetes.pdf
# Use kubernetes to install tiller
export TILLER_TAG=canary
#export TILLER_TAG=v2.7.2
kubectl --namespace=kube-system set image deployments/tiller-deploy tiller=gcr.io/kubernetes-helm/tiller:$TILLER_TAG

sudo kubectl --namespace kube-system create sa tiller
sudo kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
sudo helm init --service-account tiller

# Install Tiller
sudo /usr/local/bin/helm init

# Set up a JupyterHub
sudo helm repo add jupyterhub https://jupyterhub.github.io/helm-chart
sudo helm repo update

# Setting up a BinderHub

sudo mkdir /opt/binderhub
cd /opt/binderhub

# Create config.yaml and secret.yaml

sudo helm install jupyterhub/binderhub --version=v0.9.0dev --name=binder --namespace=binder -f secret.yaml -f config.yaml



# To add a node
# sudo kubeadm join --token TOKEN MASTER_IP:6443

# Install Minikube with KVM2 driver
# https://github.com/kubernetes/minikube/blob/master/docs/drivers.md#kvm-driver
# Install libvirt and qemu-kvm on your system, e.g.
# Debian/Ubuntu (for Debian Stretch libvirt-bin it's been replaced with libvirt-clients and libvirt-daemon-system)
# sudo apt install -y libvirt-bin qemu-kvm
# sudo usermod -a -G libvirtd $(whoami)
# newgrp libvirtd
# curl -LO https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-kvm2 && chmod +x docker-machine-driver-kvm2 && sudo mv docker-machine-driver-kvm2 /usr/bin/

# curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube

# export MINIKUBE_WANTUPDATENOTIFICATION=false
# export MINIKUBE_WANTREPORTERRORPROMPT=false
# export MINIKUBE_HOME=$HOME
# export CHANGE_MINIKUBE_NONE_USER=true
# mkdir $HOME/.kube || true
# touch $HOME/.kube/config

# export KUBECONFIG=$HOME/.kube/config
# sudo -E ./minikube start --vm-driver=kvm2

# this for loop waits until kubectl can access the api server that Minikube has created
# for i in {1..150}; do # timeout for 5 minutes
#   ./kubectl get po &> /dev/null
#   if [ $? -ne 1 ]; then
#       break
#  fi
#  sleep 2
# done
# kubectl commands are now able to interact with Minikube cluster
