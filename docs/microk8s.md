# MicroK8s role

## IPv6

Deploying in environments *without* access to natively routable IPv6 has a number of options available for resolution.

1. Network implementation of NAT64 at the network boarder and using an external DNS provider with DNS64 available.
  * [Google Public DNS64](https://developers.google.com/speed/public-dns/docs/dns64)
2. Network implementation of NAT64 at the network boarder and including DNS64 within the internal DNS forwarder.
3. Host based NAT64 and DNS64.
4. Host based NAT64 and DNS64 within Kubernetes coredns using the dns64 plugin.

These options need to be selected with your specific situation in mind. E.g., If you have no control over the infrastructure
and root access to your system then option 3 or 4 would be your only choices.

Worst case, no network support of IPv6 and only access to your host system. You wish your host system to also be able utilise
IPv6 as its default.

Configure your local host with an [IPv6 ULA address](https://en.wikipedia.org/wiki/Unique_local_address).

If using Netplan.
```yaml
network:
  version: 2
  ethernets:
    YOUR_PRIMARY_INTERFACE_NAME:
      EXISTING_SETTINGS
      addresses:
        - fd98:5fb:9ff0::2/64
      routes:
        - to: default
          via: fd98:5fb:9ff0::1
```

For your primary interface name add the `addresses` and default `routes`. Leave all other settings as is.

*NB: Default route* for IPv6 is required but does not need to exist within your network. This setting is never used as
all outbound traffic will be converted to IPv4 by the NAT64 service on the host. Kubernetes configured for IP dual-stack
or IPv6 native requires a default route to exist within the primary network space to operate correctly.

Ansible playbook example.

```yaml
- name: IP64 setup per host
  hosts: "{{ target | default('localhost') }}"
  become: true
  roles:
    - role: restek.core.network
      vars:
        network_nat64_enabled: true
        network_dns64_enabled: true
    - role: restek.core.microk8s
      vars:
        microk8s_cni_ipv6_enabled: true
        microk8s_users: [ubuntu]
```

The above playbook will install a NAT64 virtual device with universal generic settings as well as a domain name server
bound to the local interface configured to forward requests to the same domain name servers as the host
and implement DNS64 for all IPv6 responses.
