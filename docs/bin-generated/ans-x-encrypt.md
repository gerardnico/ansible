% ans-x-encrypt(1) Version Latest | Ansible-vault encrypt_string
# NAME

`ans-x-encrypt` is a `ansible-vault encrypt_string` shortcut


# SYNOPSIS

```bashusage: ansible-vault encrypt_string [-h] [--vault-id VAULT_IDS]
                                    [-J | --vault-password-file VAULT_PASSWORD_FILES]
                                    [-v] [--output OUTPUT_FILE]
                                    [--encrypt-vault-id ENCRYPT_VAULT_ID] [-p]
                                    [--show-input] [-n ENCRYPT_STRING_NAMES]
                                    [--stdin-name ENCRYPT_STRING_STDIN_NAME]
                                    [string_to_encrypt ...]

positional arguments:
  string_to_encrypt     String to encrypt

options:
  -h, --help            show this help message and exit
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
  --output OUTPUT_FILE  output file name for encrypt or decrypt; use - for
                        stdout
  --encrypt-vault-id ENCRYPT_VAULT_ID
                        the vault id used to encrypt (required if more than
                        one vault-id is provided)
  -p, --prompt          Prompt for the string to encrypt
  --show-input          Do not hide input when prompted for the string to
                        encrypt
  -n ENCRYPT_STRING_NAMES, --name ENCRYPT_STRING_NAMES
                        Specify the variable name. This argument may be
                        specified multiple times.
  --stdin-name ENCRYPT_STRING_STDIN_NAME
                        Specify the variable name for stdin
```

# EXAMPLE: ENCRYPT A STRING


```bash
# from Iterm / Cygwin / Linux / Windows WSL 
ans-x-encrypt 'the_password_to_encrypt'
# from DOS
ans-x-encrypt the_password_to_encrypt
```


It's the same as executing fom [a bash shell](ans-x-shell) inside the [Docker Image](../ans-x-docker.md)
```bash
ansible-vault encrypt_string 'the_secret_to_encrypt'
echo 'the_secret_to_encrypt' | ansible-vault encrypt_string 
```


# EXAMPLE: ENCRYPT A FILE

```bash
# windows
type cert.pem | ans-x-encrypt
# bash
ans-x-encrypt < cert.pem
```