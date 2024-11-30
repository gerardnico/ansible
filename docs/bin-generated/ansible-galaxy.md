% ansible-galaxy(1) Version Latest | Role and Collection related operations
# NAME

The `ansible-galaxy` performs various Role and Collection related operations.

Official documentation: [ansible-galaxy command line cli](https://docs.ansible.com/ansible/latest/cli/ansible-galaxy.html)

## Add-on with collections list

We have added the format `human-path` to list the collections path on the system
```bash
ansible-galax collection list --format human-path
```



# SYNOPSIS

```bashusage: ansible-galaxy [-h] [--version] [-v] TYPE ...

Perform various Role and Collection related operations.

positional arguments:
  TYPE
    collection   Manage an Ansible Galaxy collection.
    role         Manage an Ansible Galaxy role.

options:
  --version      show program's version number, config file location,
                 configured module search path, module location, executable
                 location and exit
  -h, --help     show this help message and exit
  -v, --verbose  Causes Ansible to print more debug messages. Adding multiple
                 -v will increase the verbosity, the builtin plugins currently
                 evaluate up to -vvvvvv. A reasonable level to start is -vvv,
                 connection debugging might require -vvvv. This argument may
                 be specified multiple times.
```