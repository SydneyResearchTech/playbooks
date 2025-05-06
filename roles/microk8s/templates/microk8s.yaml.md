```bash
cat <<EOT |sudo tee /etc/network/if-pre-up.d/microk8s >/dev/null
/usr/sbin/iptables -P FORWARD ACCEPT
/usr/sbin/ip6tables -P FORWARD ACCEPT
/usr/sbin/sysctl -w net.ipv4.conf.all.forwarding=1
/usr/sbin/sysctl -w net.ipv6.conf.all.forwarding=1
EOT
sudo chmod +x /etc/network/if-pre-up.d/microk8s
sudo /etc/network/if-pre-up.d/microk8s
```

```bash
sudo snap remove microk8s --purge

sudo mkdir -p /var/snap/microk8s/common
cat <<EOT |sudo tee /var/snap/microk8s/common/.microk8s.yaml
---
version: 0.1.0
addons:
  - name: dns
  - name: rbac
extraCNIEnv:
  IPv4_SUPPORT: true
  IPv4_CLUSTER_CIDR: 100.64.0.0/16
  IPv4_SERVICE_CIDR: 100.127.0.0/24
  IPv6_SUPPORT: true
  IPv6_CLUSTER_CIDR: fdf4:8ab3:60fb::/64
  IPv6_SERVICE_CIDR: fdf4:8ab3:60fb:fffe::/108
extraSANs:
  - 100.127.0.1
EOT


/var/snap/microk8s/current/args/cni-network/cni.yaml

kubectl -n kube-system set env daemonset/calico-node --containers="calico-node" CALICO_IPV6POOL_NAT_OUTGOING=true
kubectl -n kube-system patch ippool default-ipv6-ippool -p '{"spec":{"natOutgoing":true}}'
kubectl -n kube-system rollout restart deployment calico-kube-controllers
kubectl -n kube-system rollout restart daemonset calico-node


cat <<EOT |sudo tee /var/snap/microk8s/common/.microk8s.yaml
---
version: 0.1.0
addons:
  - name: dns
  - name: rbac
extraKubeAPIServerArgs:
  --authorization-mode: RBAC,Node
extraCNIEnv:
  IPv4_SUPPORT: true
  IPv4_CLUSTER_CIDR: 10.64.0.0/16
  IPv4_SERVICE_CIDR: 10.127.0.0/24
extraKubeletArgs:
  --cluster-domain: cluster.local
  --cluster-dns: 10.65.0.10
EOT

cat <<EOT |sudo tee /var/snap/microk8s/common/.microk8s.yaml
---
# /var/snap/microk8s/common/.microk8s.yaml
# https://microk8s.io/docs/explain-launch-config
version: 0.1.0
addons:
  - name: dns
  - name: rbac
extraKubeAPIServerArgs:
  --authorization-mode: RBAC,Node
extraCNIEnv:
  IPv4_SUPPORT: true
  IPv4_CLUSTER_CIDR: 100.64.0.0/16
  IPv4_SERVICE_CIDR: 100.65.0.0/24
  IPv6_SUPPORT: false
  IPv6_CLUSTER_CIDR: fd02::/64
  IPv6_SERVICE_CIDR: fd99::/108
extraKubeletArgs:
  --cluster-domain: cluster.local
  --cluster-dns: 100.65.0.10
EOT

sudo snap install microk8s --classic

microk8s status --wait
```
