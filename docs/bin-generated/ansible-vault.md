% ansible-vault(1) Version Latest | Encrypt/decrypt Ansible data
# NAME

The `ansible-vault` cli encrypts/decrypts Ansible data.

Official documentation: [ansible-vault command line cli](https://docs.ansible.com/ansible/latest/cli/ansible-vault.html)

# SYNOPSIS

```bash
usage: ansible-vault [-h] [--version] [-v]
                     {create,decrypt,edit,view,encrypt,encrypt_string,rekey}
                     ...

encryption/decryption utility for Ansible data files

positional arguments:
  {create,decrypt,edit,view,encrypt,encrypt_string,rekey}
    create              Create new vault encrypted file
    decrypt             Decrypt vault encrypted file
    edit                Edit vault encrypted file
    view                View vault encrypted file
    encrypt             Encrypt YAML file
    encrypt_string      Encrypt a string
    rekey               Re-key a vault encrypted file

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

See 'ansible-vault <command> --help' for more information on a specific
command.
```