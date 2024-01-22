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

```bash
ansible-pull -U https://github.com/SydneyResearchTech/playbooks.git [playbook.yml ...]
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
# run ansible playbook
ansible-pull -U https://github.com/SydneyResearchTech/playbooks.git microk8s-dev-env.yaml

${HOME}/.ansible/pull/ip-10-0-19-23.ap-southeast-2.compute.internal/bin/external-dns.sh
```
