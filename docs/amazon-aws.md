# playbooks/docs/amazon-aws.md

## Workstation setup

* [Installing or updating to the latest version of the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
* [Setting up the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html)
* [Ansible Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/index.html)
* [Ansible amazon.aws.aws_ec2 inventory](https://docs.ansible.com/ansible/latest/collections/amazon/aws/aws_ec2_inventory.html)

## Ansible Amazon inventory example.

```ini
# $HOME/.ansible.cfg
[defaults]
inventory = ~/.ansible/hosts
```

```yaml
# $HOME/.ansible/hosts/aws_ec2.yml
# https://docs.ansible.com/ansible/latest/collections/amazon/aws/aws_ec2_inventory.html
allow_duplicate_hosts: false
cache: true
cache_prefix: ansible_inventory_
cache_timeout: 3600
compose:
  ansible_user: tags['sydney.edu.au/resTek/defaultUser']|default('ubuntu')
groups: {}
keyed_groups:
  - key: (tags['sydney.edu.au/resTek/ansibleGroups']|default('ansibleGroups_undef')).split(',')
    separator: ''
  - key: (tags['sydney.edu.au/resTek/environment']|default(tags['sydney.edu.au:resTek:environment'])|default('_undef')).lower()
    prefix: 'env'
  - key: (tags['sydney.edu.au/resTek/owner']|default(tags['sydney.edu.au:resTek:owner'])|default('_undef')).lower()
    prefix: 'owner'
  - key: (tags['sydney.edu.au/resTek/roles']|default('_undef')).split(',')
    prefix: 'role'
  - key: tags['aws:cloudformation:stack-name']|default('_undef')
    prefix: 'stack'
  - key: placement.availability_zone
    prefix: az
  - key: placement.region
    prefix: region
profile: "{{ lookup('env','AWS_PROFILE')|default('default',true) }}"
# ADD YOUR AWS ACCOUNT REGIONS
regions: []
strict: true
```

## Notes. Random stuff.

```bash
# Get latest AMI for the CVL Desktop build.
aws ec2 describe-images \
--owners 381427642830 \
--filters 'Name=name,Values=ubuntu-jammy-22.04-amd64-server-cvl-desktop-*' \
--query 'reverse(sort_by(Images,&CreationDate))|[0].ImageId' \
--output text

# Get Subnet with public IPs and largest available address pool.
aws ec2 describe-subnets \
--filters 'Name=map-public-ip-on-launch,Values=true' 'Name=state,Values=available' \
--query 'reverse(sort_by(Subnets[?!not_null(Tags[?Key==`alpha.eksctl.io/cluster-name`].Value)], &AvailableIpAddressCount))' \
| jq '.[]'

aws ec2 describe-vpcs --vpc-ids
```
