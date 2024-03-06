# playbooks/docs/advanced_deployments.md

Global Ansible configuration for launch host.
This is a very basic starting point to develop tailored single host or site deployments.

```bash
# Create core directories for configuration settings
sudo mkdir -p /etc/ansible/{group_vars,host_vars}

# Basic Ansible configuration file
cat <<EOT |sudo tee /etc/ansible/ansible.cfg
# /etc/ansible/ansible.cfg
[defaults]
inventory = /etc/ansible/hosts.yml

[ssh_connection]
ssh_args = -o StrictHostKeyChecking=accept-new -o ControlMaster=auto -o ControlPersist=60s -o ControlPath=/tmp/%r@%h:%p
EOT

# Basic Ansible inventory file.
cat <<EOT |sudo tee /etc/ansible/hosts.yml
# /etc/ansible/hosts.yml
all:
  children:
    dev:
      hosts:
    microk8s:
      hosts:
  hosts:
    $(hostname --fqdn):
      ansible_connection: local
EOT

# Set Ansible command configuration override
cat <<EOT |sudo tee -a /etc/environment
ANSIBLE_CONFIG="/etc/ansible/ansible.cfg"
EOT

# Specific settings for launch host
sudo touch /etc/ansible/host_vars/$(hostname --fqdn).yml
```
