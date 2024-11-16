% ans-x-decrypt(1) Version Latest | Ansible-vault decrypt
# NAME

`ans-x-decrypt` is a Ansible-vault decrypt shortcut


# SYNOPSIS

```bash
usage: ansible-vault decrypt [-h] [--output OUTPUT_FILE]
                             [--vault-id VAULT_IDS]
                             [-J | --vault-password-file VAULT_PASSWORD_FILES]
                             [-v]
                             [file_name ...]

positional arguments:
  file_name             Filename

options:
  -h, --help            show this help message and exit
  --output OUTPUT_FILE  output file name for encrypt or decrypt; use - for
                        stdout
  --vault-id VAULT_IDS  the vault identity to use. This argument may be
                        specified multiple times.
  -J, --ask-vault-password, --ask-vault-pass
                        ask for vault password
  --vault-password-file VAULT_PASSWORD_FILES, --vault-pass-file VAULT_PASSWORD_FILES
                        vault password file
  -v, --verbose         Causes Ansible to print more debug messages. Adding
                        multiple -v will increase the verbosity, the builtin
                        plugins currently evaluate up to -vvvvvv. A reasonable
                        level to start is -vvv, connection debugging might
                        require -vvvv. This argument may be specified multiple
                        times.
```