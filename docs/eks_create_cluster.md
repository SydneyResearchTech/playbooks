# EKS create cluster

1. Ensure the FluxCD repository is up-to-date on the local deployment system.
2. Ensure you have a valid GitHub PAT configured.
3. Ensure you are logged into AWS with the appropriate permissions for the deployment.
4. Create a cluster deployment values file of variable overrides specific to the cluster. See details below.
5. Run the ansible playbook.
   1. `ansible-playbook -e "@$HOME/flux/clusters/restek-uat.values.yaml" restek.core.eks_create_cluster`
6. Verify the EKS template for the cluster.
7. Deploy the EKS cluster `eksctl create cluster -f $HOME/flux/clusters/${CLUSTER_NAME}.yaml`.
8. Once complete, re-run the ansible playbook to finalise the rest of the cluster resources.
   1. `ansible-playbook -e "@$HOME/flux/clusters/restek-uat.values.yaml" restek.core.eks_create_cluster`

```yaml
---
# flux/clusters/restek-uat.values.yaml
# ansible-playbook -e "@restek-uat.values.yaml" restek.core.eks_create_cluster
cluster_name: restek-uat
aws_profile: default
calico_cidr: "100.64.0.0/10"
calico_enabled: true
calico_version: "3.29.1"
karpenter_version: "1.1.1"
kubernetes_version: "1.31"
vpc_cidr: "192.168.0.0/16"
```

## Example

```console
$ eksctl create cluster -f restek-uat-bootstrap.eks.yaml
2025-01-08 11:05:47 [ℹ]  eksctl version 0.194.0
2025-01-08 11:05:47 [ℹ]  using region ap-southeast-2
2025-01-08 11:05:48 [ℹ]  setting availability zones to [ap-southeast-2a ap-southeast-2b ap-southeast-2c]
2025-01-08 11:05:48 [ℹ]  subnets for ap-southeast-2a - public:192.168.0.0/19 private:192.168.96.0/19
2025-01-08 11:05:48 [ℹ]  subnets for ap-southeast-2b - public:192.168.32.0/19 private:192.168.128.0/19
2025-01-08 11:05:48 [ℹ]  subnets for ap-southeast-2c - public:192.168.64.0/19 private:192.168.160.0/19
2025-01-08 11:05:48 [ℹ]  using Kubernetes version 1.31
2025-01-08 11:05:48 [ℹ]  creating EKS cluster "restek-uat" in "ap-southeast-2" region with
2025-01-08 11:05:48 [ℹ]  will create a CloudFormation stack for cluster itself and 0 nodegroup stack(s)
2025-01-08 11:05:48 [ℹ]  will create a CloudFormation stack for cluster itself and 0 managed nodegroup stack(s)
2025-01-08 11:05:48 [ℹ]  if you encounter any issues, check CloudFormation console or try 'eksctl utils describe-stacks --region=ap-southeast-2 --cluster=restek-uat'
2025-01-08 11:05:48 [ℹ]  Kubernetes API endpoint access will use default of {publicAccess=true, privateAccess=false} for cluster "restek-uat" in "ap-southeast-2"
2025-01-08 11:05:48 [ℹ]  CloudWatch logging will not be enabled for cluster "restek-uat" in "ap-southeast-2"
2025-01-08 11:05:48 [ℹ]  you can enable it with 'eksctl utils update-cluster-logging --enable-types={SPECIFY-YOUR-LOG-TYPES-HERE (e.g. all)} --region=ap-southeast-2 --cluster=restek-uat'
2025-01-08 11:05:48 [ℹ]
2 sequential tasks: { create cluster control plane "restek-uat",
    5 sequential sub-tasks: {
        1 task: { create addons },
        wait for control plane to become ready,
        associate IAM OIDC provider,
        no tasks,
        create IAM identity mappings,
    }
}
2025-01-08 11:05:48 [ℹ]  building cluster stack "eksctl-restek-uat-cluster"
2025-01-08 11:05:48 [ℹ]  deploying stack "eksctl-restek-uat-cluster"
2025-01-08 11:06:18 [ℹ]  waiting for CloudFormation stack "eksctl-restek-uat-cluster"
2025-01-08 11:13:54 [ℹ]  creating addon
2025-01-08 11:13:55 [ℹ]  successfully created addon
2025-01-08 11:13:55 [ℹ]  creating addon
2025-01-08 11:13:56 [ℹ]  successfully created addon
2025-01-08 11:13:56 [ℹ]  creating addon
2025-01-08 11:13:56 [ℹ]  successfully created addon
2025-01-08 11:15:59 [ℹ]  checking arn arn:aws:iam::860821382453:role/KarpenterNodeRole-restek-uat against entries in the auth ConfigMap
2025-01-08 11:15:59 [ℹ]  adding identity "arn:aws:iam::860821382453:role/KarpenterNodeRole-restek-uat" to auth ConfigMap
2025-01-08 11:16:00 [ℹ]  waiting for the control plane to become ready
2025-01-08 11:16:00 [✔]  saved kubeconfig as "/Users/dean/.kube/config"
2025-01-08 11:16:00 [ℹ]  no tasks
2025-01-08 11:16:00 [✔]  all EKS cluster resources for "restek-uat" have been created
2025-01-08 11:16:00 [✔]  created 0 nodegroup(s) in cluster "restek-uat"
2025-01-08 11:16:00 [✔]  created 0 managed nodegroup(s) in cluster "restek-uat"
2025-01-08 11:16:01 [ℹ]  "addonsConfig.autoApplyPodIdentityAssociations" is set to true; will lookup recommended pod identity configuration for "aws-ebs-csi-driver" addon
2025-01-08 11:16:01 [ℹ]  deploying stack "eksctl-restek-uat-addon-aws-ebs-csi-driver-podidentityrole-ebs-csi-controller-sa"
2025-01-08 11:16:01 [ℹ]  waiting for CloudFormation stack "eksctl-restek-uat-addon-aws-ebs-csi-driver-podidentityrole-ebs-csi-controller-sa"
2025-01-08 11:16:32 [ℹ]  waiting for CloudFormation stack "eksctl-restek-uat-addon-aws-ebs-csi-driver-podidentityrole-ebs-csi-controller-sa"
2025-01-08 11:16:32 [ℹ]  creating addon
2025-01-08 11:16:33 [ℹ]  successfully created addon
2025-01-08 11:16:34 [ℹ]  "addonsConfig.autoApplyPodIdentityAssociations" is set to true; will lookup recommended pod identity configuration for "aws-efs-csi-driver" addon
2025-01-08 11:16:34 [ℹ]  deploying stack "eksctl-restek-uat-addon-aws-efs-csi-driver-podidentityrole-efs-csi-controller-sa"
2025-01-08 11:16:34 [ℹ]  waiting for CloudFormation stack "eksctl-restek-uat-addon-aws-efs-csi-driver-podidentityrole-efs-csi-controller-sa"
2025-01-08 11:17:05 [ℹ]  waiting for CloudFormation stack "eksctl-restek-uat-addon-aws-efs-csi-driver-podidentityrole-efs-csi-controller-sa"
2025-01-08 11:17:05 [ℹ]  creating addon
2025-01-08 11:17:07 [ℹ]  successfully created addon
2025-01-08 11:17:07 [ℹ]  creating addon
2025-01-08 11:17:07 [ℹ]  successfully created addon
2025-01-08 11:17:08 [ℹ]  kubectl command should work with "/Users/dean/.kube/config", try 'kubectl get nodes'
2025-01-08 11:17:08 [✔]  EKS cluster "restek-uat" in "ap-southeast-2" region is ready
```

## Assumptions

The deployment machine and user account is:
* Configured to access the AWS account via the aws cli.
* A GitHub PAT has been configured to allow write access to the repository.
* The FluxCD repository is cloned locally on the deployment system.
  * The path to the flux directory is `$HOME/flux`. If not alter the above commands as required.

## Decomm.

```bash
aws efs delete-file-system --file-system-id
aws rds delete-db-instance --db-instance-identifier eks-restek-uat-*
aws rds delete-db-cluster --db-cluster-identifier eks-restek-uat-*

aws rds describe-
```

## ISSUES

```
$ eksctl create cluster -f restek-uat.eks.yaml
Error: fields nodeGroups, managedNodeGroups, fargateProfiles, karpenter, gitops, iam.serviceAccounts, and iam.podIdentityAssociations are not supported during cluster creation in a cluster without VPC CNI; please remove these fields and add them back after cluster creation is successful
```

```
TASK [Calico operator installation] ************************************************************************************************
fatal: [localhost]: FAILED! => {"changed": false, "msg": "Failed to apply object: b'{\"kind\":\"Status\",\"apiVersion\":\"v1\",\"metadata\":{},\"status\":\"Failure\",\"message\":\"CustomResourceDefinition.apiextensions.k8s.io \\\\\"installations.operator.tigera.io\\\\\" is invalid: metadata.annotations: Too long: must have at most 262144 bytes\",\"reason\":\"Invalid\",\"details\":{\"name\":\"installations.operator.tigera.io\",\"group\":\"apiextensions.k8s.io\",\"kind\":\"CustomResourceDefinition\",\"causes\":[{\"reason\":\"FieldValueTooLong\",\"message\":\"Too long: must have at most 262144 bytes\",\"field\":\"metadata.annotations\"}]},\"code\":422}\\n'", "reason": "Unprocessable Entity"}
```

```bash
eksctl create cluster -f $HOME/flux/clusters/restek-uat-bootstrap.eks.yaml

eksctl create nodegroup -f restek-uat.eks.yaml
eksctl create fargateprofile -f restek-uat.eks.yaml
# gitops
eksctl create iamserviceaccount -f restek-uat.eks.yaml --approve
eksctl create podidentityassociation -f restek-uat.eks.yaml
eksctl enable flux -f restek-uat.eks.yaml
```

```
% eksctl create nodegroup -f restek-uat.eks.yaml
2025-01-08 15:02:56 [!]  "aws-node" was not found
2025-01-08 15:02:56 [ℹ]  nodegroup "m7g-4xlarge" will use "" [AmazonLinux2/1.31]
2025-01-08 15:02:58 [ℹ]  1 nodegroup (m7g-4xlarge) was included (based on the include/exclude rules)
2025-01-08 15:02:58 [ℹ]  will create a CloudFormation stack for each of 1 managed nodegroups in cluster "restek-uat"
2025-01-08 15:02:59 [!]  "aws-node" was not found
2025-01-08 15:02:59 [ℹ]
2 sequential tasks: { fix cluster compatibility, 1 task: { 1 task: { create managed nodegroup "m7g-4xlarge" } }
}
2025-01-08 15:02:59 [ℹ]  checking cluster stack for missing resources
2025-01-08 15:03:00 [ℹ]  cluster stack has all required resources
2025-01-08 15:03:01 [ℹ]  building managed nodegroup stack "eksctl-restek-uat-nodegroup-m7g-4xlarge"
2025-01-08 15:03:01 [ℹ]  deploying stack "eksctl-restek-uat-nodegroup-m7g-4xlarge"
2025-01-08 15:03:01 [ℹ]  waiting for CloudFormation stack "eksctl-restek-uat-nodegroup-m7g-4xlarge"
2025-01-08 15:03:31 [ℹ]  waiting for CloudFormation stack "eksctl-restek-uat-nodegroup-m7g-4xlarge"
2025-01-08 15:04:16 [ℹ]  waiting for CloudFormation stack "eksctl-restek-uat-nodegroup-m7g-4xlarge"
2025-01-08 15:05:37 [ℹ]  waiting for CloudFormation stack "eksctl-restek-uat-nodegroup-m7g-4xlarge"
2025-01-08 15:07:12 [ℹ]  waiting for CloudFormation stack "eksctl-restek-uat-nodegroup-m7g-4xlarge"
2025-01-08 15:07:12 [ℹ]  no tasks
2025-01-08 15:07:12 [✔]  created 0 nodegroup(s) in cluster "restek-uat"
2025-01-08 15:07:13 [ℹ]  nodegroup "m7g-4xlarge" has 3 node(s)
2025-01-08 15:07:13 [ℹ]  node "ip-192-168-48-170.ap-southeast-2.compute.internal" is ready
2025-01-08 15:07:13 [ℹ]  node "ip-192-168-65-185.ap-southeast-2.compute.internal" is ready
2025-01-08 15:07:13 [ℹ]  node "ip-192-168-8-193.ap-southeast-2.compute.internal" is ready
2025-01-08 15:07:13 [ℹ]  waiting for at least 3 node(s) to become ready in "m7g-4xlarge"
2025-01-08 15:07:13 [ℹ]  nodegroup "m7g-4xlarge" has 3 node(s)
2025-01-08 15:07:13 [ℹ]  node "ip-192-168-48-170.ap-southeast-2.compute.internal" is ready
2025-01-08 15:07:13 [ℹ]  node "ip-192-168-65-185.ap-southeast-2.compute.internal" is ready
2025-01-08 15:07:13 [ℹ]  node "ip-192-168-8-193.ap-southeast-2.compute.internal" is ready
2025-01-08 15:07:13 [✔]  created 1 managed nodegroup(s) in cluster "restek-uat"
2025-01-08 15:07:15 [ℹ]  checking security group configuration for all nodegroups
2025-01-08 15:07:15 [ℹ]  all nodegroups have up-to-date cloudformation templates
```
