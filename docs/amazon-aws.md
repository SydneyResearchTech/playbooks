# playbooks/docs/amazon-aws.md

```bash
aws ec2 describe-subnets \
--filters 'Name=map-public-ip-on-launch,Values=true' 'Name=state,Values=available' \
--query 'reverse(sort_by(Subnets[?!not_null(Tags[?Key==`alpha.eksctl.io/cluster-name`].Value)], &AvailableIpAddressCount))' \
| jq '.[]'

aws ec2 describe-vpcs --vpc-ids

aws ec2 describe-images \
--owners 381427642830 \
--filters 'Name=name,Values=ubuntu-jammy-22.04-amd64-server-cvl-desktop-*' \
--query 'reverse(sort_by(Images,&CreationDate))|[0].ImageId' \
--output text
```
