# Ansible Collection - restek.core

## Using the Collection from a controlling host or jump host

*Quick start guide*

```bash
sudo apt-get update
sudo apt-get -y install pipx

# Install The University of Sydneys, Research Technology Ansible collection.
ansible-galaxy collection install --force "git+https://github.com/SydneyResearchTech/playbooks.git"

# Install any python dependancies.
pipx runpip ansible install -r $HOME/.ansible/collections/ansible_collections/restek/core/requirements.txt

# Run one of the Ansible playbooks from the collection. E.g.,
ansible-playbook -c local -e target=localhost restek.core.k8s_client
```

The above playbook installs many of the Kubernetes client tools on the local system. Many of with will appear under the
`ubuntu` default user. You can alter the default settings on the command line or by using an Ansible inventory.

## Install Ansible.

* [Install Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)

E.g., Install Ansible on Ubuntu 24.04 using pipx

```bash
sudo apt update
sudo apt install pipx jq

pipx install --include-deps ansible
pipx inject --include-apps ansible ansible-lint

ansible-galaxy collection install git+https://github.com/SydneyResearchTech/playbooks.git

# Install python dependancies
pipx runpip ansible install -r $HOME/.ansible/collections/ansible_collections/restek/core/requirements.txt
```

Ansible collections more generally

```bash
# Get the paths of your installed collections
ansible-galaxy collection list --format=json | jq -r 'keys.[]'

# Add any python dependancies for the Ansible Collections you intend to use
collection_path="FROM INSTRUCTION ABOVE"
collection="ansible.utils"             # AS AN EXAMPLE
pipx runpip ansible install -r "${collection_path}/${collection/.//}/requirements.txt"
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
 -d ~/.ansible/collections/ansible_collections/restek/core \
 [playbooks/PLAYBOOK_NAME.yaml ...]

# run ansible playbook
ansible-pull -clocal -i,localhost \
 -U https://github.com/SydneyResearchTech/playbooks.git \
 -d ~/.ansible/collections/ansible_collections/restek/core \
 [playbooks/PLAYBOOK_NAME.yaml ...]
```

## Playbooks

| Playbook                 | Purpose | Notes |
| --------                 | ------- | ----- |
| apt_upgrade_reboot       | Run full system update and reboot if required. |
| aws_sshd_pwd_enable      | Enable/disable SSH password access and optionally set user password. |
| aws_vrd_dev_lab          | Configure a Virtual Research Desktop lab in AWS. |
| edge_compute             | Configure baseline edge compute host. |
| [eks_create_cluster](docs/eks_create_cluster.md) | Deploy an EKS cluster. |
| k8s_client               | Configure Kubernetes client tools. |
| microk8s_dev_env         | Kubernetes cluster for development. Incorporating DNS resolution and configuration management, Certificate management, Load balancer and Ingress controller. | *WARNING; Alters the host system!* Uses include OIDC and other authentication integration work. Simulation of full disparate service. Includes DNS provider for specific sub-domain. |
| nvidia_toolkit_install   | Install/configure NVIDIA drivers, toolkit and CUDA. |
| os_create_server_cluster | OpenStack server cluster. | Usage example Kubernetes cluster on VMs. |
| virtual_desktop          | VDI Virtual desktop configuration |

## Roles

| Role      | Purpose | Notes |
| ----      | ------- | ----- |
| desktop   | VDI Virtual desktop with multiple container runtimes and base toolings | Uses include development, workshops |
| docker    | Docker container runtime and tools |
| k8sclient | Kubernetes client tools and plugins |
| [microk8s](docs/microk8s.md) | Install and configure MicroK8s on a single node. |

## Cloud-init example

If using cloud-init to initiate Ansible playbooks.

```yaml
#cloud-config
ansible:
  galaxy:
    actions:
    - ["ansible-galaxy","collection","install","git+https://github.com/SydneyResearchTech/playbooks.git"]
  install_method: distro
  package_name: ansible
  run_user: ubuntu
  setup_controller:
    run_ansible:
    - playbook_name: virtual_desktop.yaml
      playbook_dir: "/home/ubuntu/.ansible/collections/ansible_collections/restek/core/playbooks"
      extra_vars: target=localhost
      connection: local
apt:
  sources:
    ansible:
      source: ppa:ansible/ansible
keyboard:
  layout: us
locale: en_AU.utf-8
packages:
- git
- python3
- python3-pip
- software-properties-common
ssh_import_id: ['gh:dean-taylor']
timezone: Australia/Perth
```

## Complex deployments

For more complex deployments you will need to pre-configure an inventory on your ansible run host.
If you want the playbook to target a group of hosts, once your inventory is configured you can perform the following.

Ref.
* [How to build your inventory](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html)
* [Controlling how Ansible behaves: precedence rules](https://docs.ansible.com/ansible/latest/reference_appendices/general_precedence.html#general-precedence-rules)
* [Playbook variables - precedence](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#understanding-variable-precedence)

NB: An issue with ansible-pull and an inventory directory (as apposed to a single file) has been found.
Ansible-pull will not use the local group_vars or host_vars settings when an inventory directory is used even though the inventory rules are honoured.

Using the Ansible Collection

```bash
# Install the Ansible Collection onto the Ansible run host.
ansible-galaxy collection install git+https://github.com/SydneyResearchTech/playbooks.git

# Run the appropriate Ansible playbook.
ansible-playbook -i<PATH_TO_INVENTORY_FILE_OR_DIRECTORY> -e 'target=<GROUP_NAME>' restek.core.edge_compute
```

Using Ansible pull operation

```bash
ansible-pull -i<PATH_TO_INVENTORY_FILE_OR_DIRECTORY> -e 'target=<GROUP_NAME>' \
 -U https://github.com/SydneyResearchTech/playbooks.git \
 -d ~/.ansible/collections/ansible_collections/restek/core/playbooks \
 edge_compute.yaml

# OR add a more comprehensive configuration that includes the inventory path
cat <<EOT |sudo tee -a /etc/ansible/ansible.cfg
[defaults]
inventory = /etc/ansible/hosts.yml
[ssh_connection]
ssh_args = -o StrictHostKeyChecking=accept-new -o ControlMaster=auto -o ControlPersist=60s -o ControlPath=/tmp/%r@%h:%p
EOT

# Ansible configuration file path environment variable override
echo 'export ANSIBLE_CONFIG=/etc/ansible/ansible.cfg' |sudo tee /etc/profile.d/ansible.sh
. /etc/profile.d/ansible.sh

# Inventory file
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

# Microk8s local configuration
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

# Run playbook TEST
ansible-pull -e 'target=microk8s' --check --diff \
 -U https://github.com/SydneyResearchTech/playbooks.git \
 -d ~/.ansible/collections/ansible_collections/restek/core \
 playbooks/edge_compute.yaml

# Run playbook
ansible-pull -e 'target=microk8s' \
 -U https://github.com/SydneyResearchTech/playbooks.git \
 -d ~/.ansible/collections/ansible_collections/restek.core \
 playbooks/edge_compute.yaml
```

# Microk8s development environment ONLY

```bash
# test ansible playbook
ansible-pull -clocal -i,localhost --check --diff \
 -U https://github.com/SydneyResearchTech/playbooks.git \
 -d ~/.ansible/collections/ansible_collections/restek/core \
 playbooks/microk8s_dev_env.yaml

# run ansible playbook for localhost
ansible-pull -clocal -i,localhost \
 -U https://github.com/SydneyResearchTech/playbooks.git \
 -d ~/.ansible/collections/ansible_collections/restek/core \
 playbooks/microk8s_dev_env.yaml

# WORKAROUND. finishes the external dns configuration until this fully integrated.
finalise-external-dns.sh

# run ansible playbook from jump host, replace <hostname> with target hostname
ansible-pull -i,<hostname> \
 -U https://github.com/SydneyResearchTech/playbooks.git \
 -d ~/.ansible/collections/ansible_collections/restek/core \
 playbooks/microk8s_dev_env.yaml
```
