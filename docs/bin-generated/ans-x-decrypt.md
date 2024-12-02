% ans-x-decrypt(1) Version Latest | Ansible-vault decrypt
# NAME

`ans-x-decrypt` is an [ansible-vault](../bin-generated/ansible-vault.md) shortcut for `ansible-vault decrypt`
but works for now in a really limited cases.

We recommend to [use a shell](#how-to-decrypt-a-string) as explained below.

# HOW TO DECRYPT A STRING

It needs a shell (`bash`) to be:
* able to pass multiple line (Dos Cmd does not support it)
* don't fuck up with bash character such as dollar
* to pass stdin to decrypt


Start a shell with [ans-x-shell](../bin-generated/ans-x-shell.md)
```bash
ans-x-shell
```

then

```bash
echo '$ANSIBLE_VAULT;...<ansible vault string>' | tr -d ' ' | ansible-vault decrypt && echo
```

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

