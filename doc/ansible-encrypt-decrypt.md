# Ansible Password Encryption / Secret

## Encryption:

* for a string

```bash
# from cygwin
ansible-encrypt 'the_password_to_encrypt'
# from DOS
ansible-encrypt the_password_to_encrypt
```

* for a file
  
```bash
# windows
type cert.pem | ansible-encrypt
# bash
cat cert.pem | ansible-encrypt
```

## Decryption

It needs `bash` to be:
* able to pass multiple line (Dos Cmd does not support it)
* don't fuck up with bash character such as dollar
* to pass stdin to decrypt

```dos
ansible-bash
```

then

```bash
echo '$ANSIBLE_VAULT;...<ansible vault string>' | tr -d ' ' | ansible-vault decrypt && echo
# if vault is not in ansible.cfg, you need to pass it `--vault-id passphrase.sh`
```

