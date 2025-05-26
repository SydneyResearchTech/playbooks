# ansible_collection/docs/cloud-init.md

* [cloud-init module ref.](https://cloudinit.readthedocs.io/en/latest/reference/modules.html)
* [Ansible Setup controller](https://cloudinit.readthedocs.io/en/latest/reference/modules.html#ansible)


```cloud-config
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
```
