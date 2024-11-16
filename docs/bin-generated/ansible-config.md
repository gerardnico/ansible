% ansible-config(1) Version Latest | View ansible configuration
# NAME

The [ansible-config command line cli](https://docs.ansible.com/ansible/latest/cli/ansible-config.html) shows ansible configurations.

# SYNOPSIS

```
usage: ansible-config [-h] [--version] [-v] {list,dump,view,init} ...

View ansible configuration.

positional arguments:
  {list,dump,view,init}
    list                Print all config options
    dump                Dump configuration
    view                View configuration file
    init                Create initial configuration

options:
  --version             show program's version number, config file location,
                        configured module search path, module location,
                        executable location and exit
  -h, --help            show this help message and exit
  -v, --verbose         Causes Ansible to print more debug messages. Adding
                        multiple -v will increase the verbosity, the builtin
                        plugins currently evaluate up to -vvvvvv. A reasonable
                        level to start is -vvv, connection debugging might
                        require -vvvv. This argument may be specified multiple
                        times.
```