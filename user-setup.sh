#! /bin/sh
# Peter Pfläging <peter@pflaeging.net>
# Used for Workshops with Virtualbox CentOS Vm's

# User setup

mkdir -p $HOME/.kube
sudo cat /etc/kubernetes/admin.conf >> $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# set namespace in context
kubectl config set-context --current --namespace=kube-system
# make autocompletion for kubectl work!
kubectl completion bash >> ~/.bashrc
. ~/.bashrc
