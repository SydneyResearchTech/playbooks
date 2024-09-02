# EKS create cluster

1. Ensure the FluxCD repository is up-to-date on the system.
2. Ensure you have a valid GitHub PAT configured.
3. Ensure you are logged into AWS with the appropriate permissions for the deployment.
4. Run the ansible playbook `ansible-playbook -e 'cluster_name=CLUSTER_NAME' restek.core.eks_create_cluster`.
5. Verify the EKS template for the cluster.
6. Deploy the EKS cluster `eksctl create cluster -f ${FLUX}/clusters/${CLUSTER_NAME}.yaml`.
7. Once complete, re-run the ansible playbook to finalise the rest of the cluster resources.

## Assumptions

The deployment machine and user account is:
* Configured to access the AWS account via the aws cli.
* The FluxCD repository is cloned onto the system.
