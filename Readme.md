# Kubernestes Setup for my workshops

## Install

Here is a minimal install from:

- kubernetes 1.14.2 with kubeadm 1 all in one node
- additional deployment:
  - service account for k8s-dashboard login
  - k8s dashboard

## Content:

- kubeadm-init.sh --> Shell script to install cluster (RUN AS ROOT)
- user-setup.sh --> initial setup for non root user (run as normal user)
- deploy-dashboard.sh --> deploy kubernetes-dashboard and service account (as normal user)
- dashboard-login-info.sh --> how to open the dashboard from your host machine (relevant for virtualbox config)

---

Peter Pfläging <peter@pflaeging.net>

<https://www.pflaeging.net>

License: Apache 2.0 
