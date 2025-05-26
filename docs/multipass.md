# ansible_collection/docs/multipass.md

[Multipass](https://canonical.com/multipass)

`$HOME/.local/bin/multipass-launch`

```bash
#!/usr/bin/env bash
CPUS="4"
DISK="40G"
MEMORY="4G"
NAME=${1:-test}

set -x

cat <<EOT |multipass launch -c $CPUS -d $DISK -m $MEMORY -n $NAME --cloud-init -
#cloud-config
ansible:
  install_method: distro
  run_user: ubuntu
  galaxy:
    actions:
    - ["sudo","--user=ubuntu","--","ansible-galaxy","collection","install","git+https://github.com/SydneyResearchTech/playbooks.git"]
  package_name: ansible
apt:
  sources:
    ansible:
      source: ppa:ansible/ansible
bootcmd: []
keyboard:
  layout: us
locale: en_AU.utf8
packages:
- python3
- python3-pip
- python3-venv
package_update: true
ssh_authorized_keys: []
timezone: Australia/Perth
EOT
```
