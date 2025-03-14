# Ansible role microk8s
# src: role/microk8s/files/profile.sh
if [ -x /snap/bin/microk8s ]; then
  if which kubectl >/dev/null; then
    source <(kubectl completion bash)
  else
    alias kubectl="microk8s kubectl"
    alias helm="microk8s helm3"
    source <(microk8s kubectl completion bash)
  fi
fi
