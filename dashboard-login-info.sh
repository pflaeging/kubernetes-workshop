#! /bin/sh
# Peter Pfläging <peter@pflaeging.net>
# Used for Workshops with Virtualbox CentOS Vm's
# show URL and login info for dashboard

# get nodePort port
PORT=`kubectl get svc kubernetes-dashboard -o yaml | grep '\- nodePort:'| cut -d " " -f5`
# get ip address from internal interface (only works with virtualbox config!)
IP=`ip route | grep enp0s8 | cut -d " " -f 9`
# get token for pre-defined admin-user 
TOKEN=`kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')| grep "^token:" | cut -d: -f2`

echo To access the kubernetes-dashboard open
echo
echo https://$IP:$PORT/
echo
echo in your browser and use the following as your access token:
echo
echo $TOKEN
