# playbooks
Ansible playbooks for ansible-pull operation

## Install Ansible.

* [https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html)

```bash
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

## Prerequisite 

Ref.
* [Playbook privilege escalation](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html)

*NB:* Playbooks commonly require elevated privileges to perform tasks. The user account, local and/or remote, used to
run the playbook would typically be included as an *administrator* via *sudo*. This will allow the playbook to run as both a
standard user and be able to elevate privilege when required.

```bash
echo "<ANSIBLE_USER> ALL=(ALL) NOPASSWD:ALL" |sudo tee -a /etc/sudoers.d/ansible-user
```

## Run playbook with `ansible-pull`

Ref.
* [ansible-pull](https://docs.ansible.com/ansible/latest/cli/ansible-pull.html)

```bash
# test ansible playbook
ansible-pull -clocal -i,localhost --check --diff \
 -U https://github.com/SydneyResearchTech/playbooks.git \
 [playbook.yml ...]

# run ansible playbook
ansible-pull -clocal -i,localhost \
 -U https://github.com/SydneyResearchTech/playbooks.git \
 [playbook.yml ...]
```

## Playbooks

| Playbook | Purpose | Notes |
| -------- | ------- | ----- |
| microk8s-dev-env.yaml | Kubernetes cluster for development. Incorporating DNS resolution and configuration management, Certificate management, Load balancer and Ingress controller. | Uses include OIDC and other authentication integration work. Simulation of full disparate service. Includes full DNS provider functionality. |

## Roles

| Role | Purpose | Notes |
| ---- | ------- | ----- |
| microk8s | Install and configure MicroK8s on a single node. |

# Interum steps until fully automated

## microk8s external-dns

If you wish to select your own LB IP range, otherwise skip this step.

```bash
snap install microk8s --classic

# Minimal microk8s install add-ons
microk8s enable metallb:<IP_RANGE>
```

```bash
# test ansible playbook
ansible-pull -clocal -i,localhost --check --diff \
 -U https://github.com/SydneyResearchTech/playbooks.git \
 microk8s-dev-env.yaml

# run ansible playbook for localhost
ansible-pull -clocal -i,localhost \
 -U https://github.com/SydneyResearchTech/playbooks.git \
 microk8s-dev-env.yaml

# WORKAROUND. finishes the external dns configuration until this fully integrated.
finalise-external-dns.sh

# run ansible playbook from jump host, replace <hostname> with target hostname
ansible-pull -i,<hostname> \
 -U https://github.com/SydneyResearchTech/playbooks.git \
 microk8s-dev-env.yaml
```

For more complex deployments you will need to pre-configure an inventory on your ansible run host.
If you want the playbook to target a group of hosts, once your inventory is configured you can perform the following.

Ref.
* [How to build your inventory](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html)
* [Controlling how Ansible behaves: precedence rules](https://docs.ansible.com/ansible/latest/reference_appendices/general_precedence.html#general-precedence-rules)
* [Playbook variables - precedence](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#understanding-variable-precedence)

NB: An issue with ansible-pull and an inventory directory (as apposed to a single file) has been found.
Ansible-pull will not use the local group_vars or host_vars settings when an inventory directory is used even though the inventory rules are honoured.

```bash
ansible-pull -i<PATH_TO_INVENTORY_FILE_OR_DIRECTORY> -e 'target=<GROUP_NAME>' \
 -U https://github.com/SydneyResearchTech/playbooks.git \
 microk8s-dev-env.yaml

# OR add a more comprehensive configuration that includes the inventory path
cat <<EOT |sudo tee -a /etc/ansible/ansible.cfg
[defaults]
inventory = /etc/ansible/hosts.yml
[ssh_connection]
ssh_args = -o StrictHostKeyChecking=accept-new -o ControlMaster=auto -o ControlPersist=60s -o ControlPath=/tmp/%r@%h:%p
EOT

echo 'export ANSIBLE_CONFIG=/etc/ansible/ansible.cfg' |sudo tee /etc/profile.d/ansible.sh
. /etc/profile.d/ansible.sh

cat <<EOT |sudo tee /etc/ansible/hosts.yml
all:
  children:
    microk8s:
      hosts:
        $(hostname):
  hosts:
    $(hostname):
      ansible_connection: local
EOT

sudo mkdir -p /etc/ansible/group_vars

cat <<EOT |sudo /etc/ansible/group_vars/microk8s.yml
---
# /etc/ansible/group_vars/microk8s.yml
microk8s_enable:
  - cert-manger
  - dns
  - ha-cluster
  - helm3
  - ingress
  - observability
  - rbac
EOT

ansible-pull -e 'target=<GROUP_NAME>' \
 -U https://github.com/SydneyResearchTech/playbooks.git \
 microk8s-dev-env.yaml
```
