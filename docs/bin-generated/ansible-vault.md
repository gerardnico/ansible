% ansible-vault(1) Version Latest | Encrypt/decrypt Ansible data
# NAME

The `ansible-vault` cli encrypts/decrypts Ansible data.

Official documentation: [ansible-vault command line cli](https://docs.ansible.com/ansible/latest/cli/ansible-vault.html)

## Pass support for vault-id

The `vault-id` is the passphrase that encrypts the secret in `Ansible Vault` 

`Ansible X` scripts support [pass](../ans-x-pass.md) as secret store
to store and retrieve your `vault-id` by setting the `ANS_X_VAULT_ID_PASS` environment variable.

Example:
```bash
# if you get your vault id with
pass ansible/vault-id
# you need to set ANS_X_CONNECTION_PASSWORD_PASS to
export ANS_X_VAULT_ID_PASS=ansible/vault-id
```
`Ans-x` will then create the [ANSIBLE_VAULT_PASSWORD_FILE](https://docs.ansible.com/ansible/devel/reference_appendices/config.html#envvar-ANSIBLE_VAULT_PASSWORD_FILE)
Otherwise, you can create it manually.

## Encrypt/Decrypt Wrapper

We support wrappers for a one argument encryption and decryption
* Encrypt: see [ans-x-encrypt](../bin-generated/ans-x-encrypt.md)
* Decrypt: see [ans-x-decrypt](../bin-generated/ans-x-decrypt.md)

# SYNOPSIS

```bash
```