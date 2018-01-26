# BinderHub Deployment on Jetstream

I'm testing out a deployment of [BinderHub](https://binderhub.readthedocs.io/en/latest/) on [XSEDE Jetstream](https://use.jetstream-cloud.org/application/help). These tests are tested on a hosted [Ubuntu 16.04 image](https://use.jetstream-cloud.org/application/images/107).

[Medium post on setting up Kubernetes on Ubuntu 16](https://medium.com/@SystemMining/setup-kubenetes-cluster-on-ubuntu-16-04-with-kubeadm-336f4061d929)

My goal is to deploy a functioning BinderHub that can start Jupyter Notebooks /w RStudio on from my personal Github repository pages. I eventually want to scale up, adding compute nodes to the master node.

# Kubernetes

BinderHub runs on a Kubernetes cluster. 

[Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/) manages resources on the cloud.

BinderHub has instructions on how to install Kubernetes on GoogleCloud, but these don't work for CyVerse Atmosphere or XSEDE Jetstream instances running against OpenStack. 

I change some of the installation steps in my [Ubuntu16_build.sh](https://github.com/tyson-swetnam/binderhub_test/blob/master/ubuntu16_build.sh) file located in this repo.

I followed the custom deployment of [Kubernetes on Ubuntu](https://kubernetes.io/docs/getting-started-guides/ubuntu/) to initialize the Kubernetes master node.

# Helm

[Helm](https://docs.helm.sh/using_helm/#installing-helm) configures and controls Kubernetes, and is required by BinderHub.

# JupyterHub

I want to deploy Jupyter Notebooks and RStudio via [JupyterHub](https://jupyterhub.readthedocs.io/en/latest/)

[Zero to JupyterHub](https://zero-to-jupyterhub.readthedocs.io/en/latest/index.html)

[Zero to JupyterHub .pdf](https://docs.helm.sh/using_helm/#installing-helm)

# RStudio

[Rocker](https://hub.docker.com/u/rocker/) hosts useful RStudio images which are ready to do ([spatial](https://hub.docker.com/r/rocker/geospatial/)) analyses. 
