# BinderHub Deployment on Jetstream

I'm testing out a deployment of [BinderHub](https://binderhub.readthedocs.io/en/latest/) on [XSEDE Jetstream](https://use.jetstream-cloud.org/application/help). These tests are using a hosted [Ubuntu 16.04 image](https://use.jetstream-cloud.org/application/images/107).

My goal is to have a functioning BinderHub that I can start Jupyter Notebooks /w RStudio on from my Github Pages. I also want to be able to scale up by adding nodes to the master as workers.

# Kubernetes

Binder requires [Kubernetes](https://kubernetes.io/docs/tasks/tools/install-kubectl/) and has instructions on how to install Kubernetes on GoogleCloud. I had to change some of the installation steps to function on my Ubuntu instance.

I had to install a custom deployment of [Kubernetes on Ubuntu](https://kubernetes.io/docs/getting-started-guides/ubuntu/) to initialize the Kubernetes node.

# Helm



# BinderHub


# JupyterHub

[Zero to JupyterHub](https://zero-to-jupyterhub.readthedocs.io/en/latest/index.html)


# RStudio

[Rocker](https://hub.docker.com/u/rocker/) hosts useful RStudio images which are ready to do ([spatial](https://hub.docker.com/r/rocker/geospatial/)) analyses. 
