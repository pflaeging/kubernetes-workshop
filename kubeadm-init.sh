#! /bin/sh
# Peter Pfläging <peter@pflaeging.net>
# Used for Workshops with Virtualbox CentOS Vm's

# kubeadm

MYIP=`ip route | grep enp0s8 | cut -d " " -f 9`

# become superuser
sudo -s
# turnoff swap
swapoff -a
sed -i 's$/dev/mapper/centos-swap$# /dev/mapper/centos-swap$g' /etc/fstab
# get kubernetes upstream repo
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF

# Set SELinux in permissive mode (effectively disabling it)
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
# free some ports from firewalld just in case
firewall-cmd --permanent --add-port=8001/tcp
firewall-cmd --permanent --add-port=8443/tcp
firewall-cmd --permanent --add-port=6443/tcp
firewall-cmd --reload
# install kubernetes
yum install -y kubelet kubeadm kubectl --disableexcludes=kubernetes
# enable kubelet
systemctl enable --now kubelet
# register my hostname
echo $MYIP workshop.pflaeging.net >> /etc/hosts
# start kubeadm 
kubeadm init --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=NumCPU --api-advertise-addresses=$MYIP
# install network canal
kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/canal/rbac.yaml
kubectl --kubeconfig=/etc/kubernetes/admin.conf apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/canal/canal.yaml
