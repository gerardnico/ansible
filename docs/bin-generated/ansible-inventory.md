% ansible-inventory(1) Version Latest | Show Ansible inventory information
# NAME

The `ansible-inventory` cli shows Ansible inventory information, by default it uses the inventory script JSON format.

Official documentation: [ansible-inventory command line cli](https://docs.ansible.com/ansible/latest/cli/ansible-inventory.html)

# SYNOPSIS

```bash
usage: ansible-inventory [-h] [--version] [-v] [-i INVENTORY] [-l SUBSET]
                         [--vault-id VAULT_IDS]
                         [-J | --vault-password-file VAULT_PASSWORD_FILES]
                         [--playbook-dir BASEDIR] [-e EXTRA_VARS] [--list]
                         [--host HOST] [--graph] [-y] [--toml] [--vars]
                         [--export] [--output OUTPUT_FILE]
                         [group]

Show Ansible inventory information, by default it uses the inventory script
JSON format

positional arguments:
  group                 The name of a group in the inventory, relevant when
                        using --graph

options:
  --export              When doing an --list, represent in a way that is
                        optimized for export,not as an accurate representation
                        of how Ansible has processed it
  --output OUTPUT_FILE  When doing --list, send the inventory to a file
                        instead of to the screen
  --playbook-dir BASEDIR
                        Since this tool does not use playbooks, use this as a
                        substitute playbook directory. This sets the relative
                        path for many features including roles/ group_vars/
                        etc.
  --toml                Use TOML format instead of default JSON, ignored for
                        --graph
  --vars                Add vars to graph display, ignored unless used with
                        --graph
  --vault-id VAULT_IDS  the vault identity to use. This argument may be
                        specified multiple times.
  --vault-password-file VAULT_PASSWORD_FILES, --vault-pass-file VAULT_PASSWORD_FILES
                        vault password file
  --version             show program's version number, config file location,
                        configured module search path, module location,
                        executable location and exit
  -J, --ask-vault-password, --ask-vault-pass
                        ask for vault password
  -e EXTRA_VARS, --extra-vars EXTRA_VARS
                        set additional variables as key=value or YAML/JSON, if
                        filename prepend with @. This argument may be
                        specified multiple times.
  -h, --help            show this help message and exit
  -i INVENTORY, --inventory INVENTORY, --inventory-file INVENTORY
                        specify inventory host path or comma separated host
                        list. --inventory-file is deprecated. This argument
                        may be specified multiple times.
  -l SUBSET, --limit SUBSET
                        further limit selected hosts to an additional pattern
  -v, --verbose         Causes Ansible to print more debug messages. Adding
                        multiple -v will increase the verbosity, the builtin
                        plugins currently evaluate up to -vvvvvv. A reasonable
                        level to start is -vvv, connection debugging might
                        require -vvvv. This argument may be specified multiple
                        times.
  -y, --yaml            Use YAML format instead of default JSON, ignored for
                        --graph

Actions:
  One of following must be used on invocation, ONLY ONE!

  --graph               create inventory graph, if supplying pattern it must
                        be a valid group name. It will ignore limit
  --host HOST           Output specific host info, works as inventory script.
                        It will ignore limit
  --list                Output all hosts info, works as inventory script
```