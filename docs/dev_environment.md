# Development environment(s)

## Conventions

By default the development follows a number of conventions to simplify utilisation. These can be altered,
however by standardising these settings the uniform environment helps to collaborate between team members.

| Convention | Default | Notes |
| ---------- | ------- | ----- |
| Domain name | fake.sydney.edu.au | Altering the primary DN will also alter the settings that rely on it bellow. |
| External domain | fake.sydney.edu.au |
| Load balancer IP pool | The first five IP block that do not respond to ICMP echo requests on the primary network interface. |
| Certificate management | There are self signed certs and a CA registered with the development host. |
| Email | smtp.fake.sydney.edu.au | This service will forward all email to the local users inbox. Email does not leave the local host. |

## Future integrations

Active directory for Kerberos and LDAP integration development and testing.
OpenID Connect (OIDC) authentication provider. Currently using stand alone KeyCloak service but not part of the Ansible deployment.
