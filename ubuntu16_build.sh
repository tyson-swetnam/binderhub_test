#!/bin/bash

# https://www.techrepublic.com/article/how-to-quickly-install-kubernetes-on-ubuntu/

# Get the MAC and IP address 
ifconfig -a

# Update Ubuntu
sudo apt-get update && apt-get install -y apt-transport-https

# Add Key
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add 
# Add Kubernetes to sources list
sudo touch /etc/apt/sources.list.d/kubernetes.list 
sudo su
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main"  >> /etc/apt/sources.list.d/kubernetes.list 
exit

# adds autocompletion
echo "source <(kubectl completion bash)" >> ~/.bashrc

# Download and install Kubernetes
# https://kubernetes.io/docs/setup/independent/create-cluster-kubeadm/
sudo apt-get update --allow-unauthenticated
sudo apt-get install -y kubelet kubeadm kubectl kubernetes-cni 

# Start a Kubernetes Cluster, using --pod-network-cidr flag to run `flannel` pod controller
sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# create a home profile config
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Deploy pod network controller
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.9.1/Documentation/kube-flannel.yml

# Clean the master
kubectl taint nodes --all node-role.kubernetes.io/master-
# Confirm installation: kubectl get pods --all-namespaces

# Give user sudo 
export EMAIL_ADDRESS="tswetnam@cyverse.org"
kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$EMAIL_ADDRESS

# Binding
kubectl create clusterrolebinding permissive-binding \
 --clusterrole=cluster-admin \
 --user=admin \
 --user=kubelet \
 --group=system:serviceaccounts

# Download Helm
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash

# Setup service for Tiller
kubectl --namespace kube-system create serviceaccount tiller
# give service account permissions
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
# setup Helm
helm init --service-account tiller
# Secure Helm
kubectl --namespace=kube-system patch deployment tiller-deploy --type=json --patch='[{"op": "add", "path": "/spec/template/spec/containers/0/command", "value": ["/tiller", "--listen=localhost:44134"]}]'
# To force remove Helm: helm reset --force

# Setting up a BinderHub
sudo mkdir binderhub
cd binderhub

# Set up a JupyterHub
sudo helm repo add jupyterhub https://jupyterhub.github.io/helm-chart
sudo helm repo update

# Create config.yaml and secret.yaml
sudo helm install jupyterhub/binderhub --version=v0.9.0dev --name=binder --namespace=binder -f secret.yaml -f config.yaml

# Print the IP Address of the console
kubectl --namespace=binder get svc proxy-public
