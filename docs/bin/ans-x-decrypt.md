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
${SYNOPSIS}
```

