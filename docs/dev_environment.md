# Development environment(s)

## WARNINGS

The playbook for this service makes extensive alterations to the host system. It is recommended that this be used within a separate virtual machine or dedicated system, NOT on your workstation directly.

## Conventions

By default the development follows a number of conventions to simplify utilisation. These can be altered,
however by standardising these settings the uniform environment helps to collaborate between team members.

| Convention | Default | Notes |
| ---------- | ------- | ----- |
| Domain name | fake.sydney.edu.au | Altering the primary DN will also alter the settings that rely on it bellow. |
| External domain | fake.sydney.edu.au | Available to all resources including the host machine, not available out side of the host system. |
| Load balancer IP pool | The first block of five IP addresses that do not respond to ICMP echo requests on the primary network interface. |
| Certificate management | There are self signed certs and a CA registered with the development host. |
| Email | smtp.fake.sydney.edu.au | This service will forward all email to the local users inbox. Email does not leave the local host. |

## Future integrations

* Active directory for Kerberos and LDAP integration development and testing.
  Current state. Developed deployment utilising Samba4 as the active directory provider at 2012R2 forest level.
  Requires. Full hypervisor or bare metal deployment due to the low level file system required.
  Using LXD (+ KVM) for most deployments.
  Where nested hypervisor is not supported, such as Amazon, requires alterations to the CloudFormation templates to include a separate VM.
  Not currently part of Ansible playbooks.
* OpenID Connect (OIDC) authentication provider.
  Currently using stand alone KeyCloak service but not part of the Ansible deployment.
