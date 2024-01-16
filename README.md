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
