microk8s
=========

MicroK8s configuration management.

Requirements
------------


Role Variables
--------------

| microk8s_enable | []string MicroK8s add-ons to enable |
| microk8s_calicoctl_version | string calicoctl version number to install on host |
| microk8s_wireguard_enabled | boolean Wireguard installation for Calico encryption in transit layer |
| microk8s_hostpaths | []structure Dynamic Storage Class for locally attached paths |
| microk8s_metallb_range | Load balancer IP addresses range for initial MetalLB configuration |

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
