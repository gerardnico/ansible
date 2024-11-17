% ans-x-decrypt(1) Version Latest | Ansible-vault decrypt
# NAME

`ans-x-decrypt` is a Ansible-vault decrypt shortcut


# SYNOPSIS

```bash${SYNOPSIS}
```

# HOW TO DECRYPT A STRING

It needs `bash` to be:
* able to pass multiple line (Dos Cmd does not support it)
* don't fuck up with bash character such as dollar
* to pass stdin to decrypt

```bash
ans-x-bash
```

then

```bash
echo '$ANSIBLE_VAULT;...<ansible vault string>' | tr -d ' ' | ansible-vault decrypt && echo
```