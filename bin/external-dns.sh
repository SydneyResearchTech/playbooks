#!/usr/bin/env bash
#
HOST_IP=$(ip -4 addr show ens5 scope global |sed -n 's/^\s*inet\s*\([0-9.]*\).*$/\1/p')
TSIG_SECRET=$(sed -n 's/^\s*secret\s*"\(.*\)".*$/\1/p' /etc/bind/tsig-key-fake.sydney.edu.au)
TSIG_NAME=$(sed -n 's/^\s*key\s*"\(.*\)".*$/\1/p' /etc/bind/tsig-key-fake.sydney.edu.au)

helm repo add external-dns https://kubernetes-sigs.github.io/external-dns/
helm repo update

cat <<EOT |helm upgrade external-dns external-dns/external-dns -i --create-namespace -f - -nexternal-dns
provider:
  name: rfc2136
extraArgs:
  - --rfc2136-host=${HOST_IP}
  - --rfc2136-port=53
  - --rfc2136-zone=fake.sydney.edu.au
  - --rfc2136-tsig-secret=${TSIG_SECRET}
  - --rfc2136-tsig-secret-alg=hmac-sha256
  - --rfc2136-tsig-keyname=${TSIG_NAME}
  - --rfc2136-tsig-axfr
  - --txt-owner-id=k8s
  - --txt-prefix=external-dns
  - --domain-filter=fake.sydney.edu.au
EOT
