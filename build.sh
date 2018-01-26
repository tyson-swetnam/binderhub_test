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
# Install libvirt and qemu-kvm on your system, e.g.
# Debian/Ubuntu (for Debian Stretch libvirt-bin it's been replaced with libvirt-clients and libvirt-daemon-system)

sudo apt install -y libvirt-bin qemu-kvm

sudo usermod -a -G libvirtd $(whoami)
newgrp libvirtd
curl -LO https://storage.googleapis.com/minikube/releases/latest/docker-machine-driver-kvm2 && chmod +x docker-machine-driver-kvm2 && sudo mv docker-machine-driver-kvm2 /usr/bin/

curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 && chmod +x minikube

export MINIKUBE_WANTUPDATENOTIFICATION=false
export MINIKUBE_WANTREPORTERRORPROMPT=false
export MINIKUBE_HOME=$HOME
export CHANGE_MINIKUBE_NONE_USER=true
mkdir $HOME/.kube || true
touch $HOME/.kube/config

export KUBECONFIG=$HOME/.kube/config
sudo -E ./minikube start --vm-driver=kvm2

# this for loop waits until kubectl can access the api server that Minikube has created
for i in {1..150}; do # timeout for 5 minutes
   ./kubectl get po &> /dev/null
   if [ $? -ne 1 ]; then
      break
  fi
  sleep 2
done
# kubectl commands are now able to interact with Minikube cluster

# download and install Helm

curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
sudo helm init

# https://media.readthedocs.org/pdf/zero-to-jupyterhub-with-kubernetes/stable/zero-to-jupyterhub-with-kubernetes.pdf
# Use kubernetes to install tiller

kubectl --namespace kube-system create sa tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
sudo helm init --service-account tiller

# Setting up a BinderHub

sudo mkdir /opt/binderhub
cd /opt/binderhub
