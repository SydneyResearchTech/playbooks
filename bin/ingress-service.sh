#!/usr/bin/env bash
#
# https://microk8s.io/docs/addon-metallb
# MetalLB installed?
microk8s status --format short |grep -q 'core/metallb: enabled' || { >&2 echo 'microk8s enable metallb:RANGE(S)'; exit 127; }

# Apply a Service to configure LB
cat <<EOT |kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: ingress
  namespace: ingress
spec:
  selector:
    name: nginx-ingress-microk8s
  type: LoadBalancer
  ports:
    - name: http
      protocol: TCP
      port: 80
      targetPort: 80
    - name: https
      protocol: TCP
      port: 443
      targetPort: 443
EOT

# Configure Nginx Ingress to use the LB IP assignment
kubectl -ningress get daemonset nginx-ingress-microk8s-controller -o yaml \
	| sed -e 's|- --publish-status-address=.*|- --publish-service=$(POD_NAMESPACE)/ingress|' \
	| kubectl apply -f -
