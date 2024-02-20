# playbooks
Ansible playbooks for ansible-pull operation

Install Ansible.

* [https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html)

```bash
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

Run playbook with `ansible-pull`

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
| microk8s-dev-env.yaml | Kubernetes cluster for development. Incorporating DNS resolution and configuration management, Certificate management, Load balancer and Ingress controller. | Uses include OIDC and other authentication integration work. Symulation of full disparate service. Includes full DNS provider functionality. |

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

${HOME}/.ansible/pull/$(hostname --fqdn)/bin/external-dns.sh

# run ansible playbook from jump host, replace <hostname> with target hostname
ansible-pull -i,<hostname> \
 -U https://github.com/SydneyResearchTech/playbooks.git \
 microk8s-dev-env.yaml
```

For more complex deployments you will need to pre-configure an inventory on your ansible run host.
If you want the playbook to target a group of hosts, once your inventory is configured you can perform the following.

Ref.
* [How to build your inventory](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html)

```bash
ansible-pull -i<PATH_TO_INVENTORY_FILE_OR_DIRECTORY> -e 'playbook_hosts=<GROUP_NAME>' \
 -U https://github.com/SydneyResearchTech/playbooks.git \
 microk8s-dev-env.yaml
```
