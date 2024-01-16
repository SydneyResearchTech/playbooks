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

# Interum steps until fully automated

## microk8s external-dns

```bash
snap install microk8s --classic

# Minimal microk8s install add-ons
microk8s enable dns
microk8s enable ingress
micork8s enable metallb:<IP_RANGE>

# run ansible playbook
ansible-pull -U https://github.com/SydneyResearchTech/playbooks.git microk8s-dev-env.yaml

${HOME}/.ansible/pull/ip-10-0-19-23.ap-southeast-2.compute.internal/bin/ingress-service.sh
${HOME}/.ansible/pull/ip-10-0-19-23.ap-southeast-2.compute.internal/bin/external-dns.sh
```
