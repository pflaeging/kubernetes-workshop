#! /bin/sh
# Peter Pfläging <peter@pflaeging.net>
# Used for Workshops with Virtualbox CentOS Vm's

kubectl apply -f kubernetes-dashboard.yaml
kubectl create -f admin-user.yaml
kubectl patch service kubernetes-dashboard --type='json' -p='[{"op":"replace","path":"/spec/type","value":"NodePort"}]' -n kube-system
