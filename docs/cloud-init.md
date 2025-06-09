# ansible_collection/docs/cloud-init.md

* [cloud-init module ref.](https://cloudinit.readthedocs.io/en/latest/reference/modules.html)
* [Ansible Setup controller](https://cloudinit.readthedocs.io/en/latest/reference/modules.html#ansible)

```cloud-config
#cloud-config
bootcmd:
- useradd -G adm,cdrom,sudo,dip,lxd -m -s /bin/bash -U ubuntu || true
keyboard:
  layout: us
locale: en_AU.utf8
packages:
- pipx
- python3
- python3-pip
- python3-venv
package_update: true
runcmd:
- su -c 'pipx install --include-deps ansible' -- ubuntu
- su -c 'pipx inject --include-apps ansible ansible-lint' -- ubuntu
- >
  su -c
  '$(pipx environment --value=PIPX_BIN_DIR)/ansible-galaxy collection install --force "git+https://github.com/SydneyResearchTech/playbooks.git"'
  -- ubuntu
- su -c 'pipx runpip ansible install -r $HOME/.ansible/collections/ansible_collections/restek/core/requirements.txt' -- ubuntu
ssh_authorized_keys: []
timezone: Australia/Sydney
users: []
```

The above cloud-init configuration does not use the Ansible module due to the fact that `pipx` is used to
manage the Ansible install and dependencies. As well as in the cloud-init run order the Ansible module is executed before the
Runcmd module and the `installation_method` key is at present a mandatory field.

To use `pipx` all the Ansible operations have been moved into the runcmd module.

The cloud-init default user creation has also been disabled and moved into the bootcmd module. This ensures that the Ansible
run user is present before the runcmd module is executed.
