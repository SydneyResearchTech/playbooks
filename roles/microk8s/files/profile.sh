# Ansible role microk8s
# src: role/microk8s/files/profile.sh
if [ -x /snap/bin/microk8s ]; then
  if ! which kubectl >/dev/null; then
    alias kubectl="microk8s kubectl"
    alias helm="microk8s helm3"
  fi
fi
