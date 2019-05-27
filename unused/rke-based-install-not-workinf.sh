#! /bin/sh
# Peter Pfläging <peter@pflaeging.net>
# Used for Workshops with Virtualbox CentOS Vm's

# get rke
curl -L -o /usr/local/bin/rke https://github.com/rancher/rke/releases/download/v0.1.18/rke_linux-amd64
chmod +x /usr/local/bin/rke
# get kubectl
curl -L -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x /usr/local/bin/kubectl
# generate SSH key
ssh-keygen
# authorize key
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
# copy cluster-config in place! Pls look for correct ip value
cp cluster-base.yml ~/cluster.yml
cd ~
kubectl completion bash >> ~/.bashrc
# startup cluster
rke up
# make config for kubectl
mkdir -p ~/.kube
# copy authorize info in place
cat kube_config_cluster.yml  >> ~/.kube/config
# ready!
firewall-cmd --permanent --add-port=8001/tcp
firewall-cmd --permanent --add-port=8443/tcp
firewall-cmd --permanent --add-port=6443/tcp
firewall-cmd --reload

# set namespace in context
kubectl config set-context --current --namespace=kube-system

kubectl patch service kubernetes-dashboard --type='json' -p='[{"op":"replace","path":"/spec/type","value":"NodePort"}]'


# http://192.168.56.108:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/ 
kubectl get secret `kubectl get sa admin-user -n kube-system -o yaml | grep token | cut -d " " -f 3` -n kube-system -o yaml | grep token: