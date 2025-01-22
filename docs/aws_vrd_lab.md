# playbooks/aws_vrd_lab
# Virtual Research Desktop Lab deployed into AWS

Creates:
* VPC
* IP dual-stack network interconnects (IPv4 and IPv6)
* Desktop launch template
* Auto scaling group

Scale

```bash
STACK_NAME='??????'

aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $STACK_NAME-asg \
--query 'AutoScalingGroups[0].DesiredCapacity' \
--output text

aws autoscaling set-desired-capacity --auto-scaling-group-name $STACK_NAME-asg --desired-capacity 0

aws ec2 describe-instances --filters "Name=tag:aws:autoscaling:groupName,Values=$STACK_NAME-asg" \
--query 'Reservations[].Instances[].[PublicDnsName,Ipv6Address,State.Name]' \
--output text
```

Decommission

```bash
STACK_NAME='??????'

aws autoscaling delete-auto-scaling-group --auto-scaling-group-name $STACK_NAME-asg
aws cloudformation delete-stack --stack-name $STACK_NAME-vrd-launch-template
aws cloudformation delete-stack --stack-name $STACK_NAME-vpc

# Checks
aws cloudformation describe-stacks --stack-name $STACK_NAME-vrd-launch-template --query 'Stacks[0].StackStatus'
aws cloudformation describe-stacks --stack-name $STACK_NAME-vpc --query 'Stacks[0].StackStatus'
```
