# How to connect with SSH?

## About

This page shows you how you can pass your secret to SSH.

There are 2 secrets type:
* a [private key](#private-key-authentication-how-to-pass-a-private-key-with-ansible_private_key_file-env)
* a [password](#how-to-connect-with-a-password-authentication)

> [!TIP]
> For the user, you can define it:
> * inside your inventory file with the [ansible_user](https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html#connection-variables), 
> * at the command line passing the same var 
> * or via the ANSIBLE_USER env
> 
> Example with the `ANSIBLE_USER` env
> ```bash
> export ANSIBLE_USER=root
> ```

## Private Key Authentication: How to pass a private Key with ANSIBLE_PRIVATE_KEY_FILE env

All this method will automatically set the ansible environment variable [ANSIBLE_PRIVATE_KEY_FILE](https://docs.ansible.com/ansible/devel/reference_appendices/config.html#envvar-ANSIBLE_PRIVATE_KEY_FILE)
for you.


### How to use a private key stored in Pass

We support passing a private key stored in the [pass secret manager](ans-x-pass.md)

You need to set the variable `ANS_X_SSH_KEY_PASS` to the location of your private key

Example:
```bash
# if you get your key with
pass ansible/ssh-key
# you need to set ANS_X_SSH_KEY_PASS to
export ANS_X_SSH_KEY_PASS=ansible/ssh-key
```


### How to use a protected private keys stored in .ssh


To define a protected key, you can use the environment variable `ANS_X_SSH_KEY_PASSPHRASE_xxx`:
  * `ANS_X_SSH_KEY_PASSPHRASE_` is a prefix
  * `xxxx` is the name of the key
  * the value is the passphrase

Example for the protected key stored at `~/.ssh/id_rsa` with as passphrase `my-secret` 
```bash
export ANS_X_SSH_KEY_PASSPHRASE_id_rsa=my-secret
```

The key should be in your SSH home directory
* Linux: `~/.ssh`
* Windows: `%USERPROFILE%/.ssh`

### How to use a non-protected key stored in .ssh

You need to:
* set your private key in `~/.ssh`
* set the [ANSIBLE_PRIVATE_KEY_FILE](https://docs.ansible.com/ansible/devel/reference_appendices/config.html#envvar-ANSIBLE_PRIVATE_KEY_FILE) to the file name

Example:
```bash
export ANSIBLE_PRIVATE_KEY_FILE=my_key
```



## How to connect with a password authentication

### How to use a password stored in Pass

We support passing passwords stored in the [pass secret manager](ans-x-pass.md)

You need to set to the location of your password the variable
* `ANS_X_PASSWORD_PASS`: the user password
* `ANS_X_BECOME_PASSWORD_PASS`: the become user password

Example:
* User password
```bash
# if you get your user password with
pass ansible/ssh-password
# you need to set ANS_X_PASSWORD_PASS to
export ANS_X_PASSWORD_PASS=ansible/ssh-password
```
* Become User Password
```bash
# if you get your user become password with
pass ansible/ssh-become-password
export ANS_X_BECOME_PASSWORD_PASS=ansible/ssh-become-password
```

When these variables are set, the following ansible environment variable are set:
* [ANSIBLE_CONNECTION_PASSWORD_FILE](https://docs.ansible.com/ansible/devel/reference_appendices/config.html#envvar-ANSIBLE_CONNECTION_PASSWORD_FILE): the login password
* [ANSIBLE_BECOME_PASSWORD_FILE](https://docs.ansible.com/ansible/devel/reference_appendices/config.html#envvar-ANSIBLE_BECOME_PASSWORD_FILE): the become password file

### How to connect with a password via environment variable

You can define the [connection variables](https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html#connection-variables):
in your inventory file with environment variable
```yml
server:
  hosts:
    ansible-host-name:
      # The ip/name of the target host to use instead of inventory_hostname
      ansible_host: x.x.x.x
      # The user Ansible ‘logs in’ as.
      ansible_user: "user"
      # The user password
      ansible_password: "{{ lookup('env', 'ANS_X_ANSIBLE_PASSWORD') }}"
      # The become user
      ansible_become_user: root
      # The become user password (if no sudo)
      ansible_become_password: "{{ lookup('env', 'ANS_X_ANSIBLE_BECOME_PASSWORD') }}"
```

You then need to create the env:
* `ANS_X_ANSIBLE_PASSWORD`
* and `ANS_X_ANSIBLE_BECOME_PASSWORD`


### How to connect with a password file via environment variable

You can set the password via file. You need to:
* create the file
* and set the following environments:
  * [ANSIBLE_CONNECTION_PASSWORD_FILE](https://docs.ansible.com/ansible/devel/reference_appendices/config.html#envvar-ANSIBLE_CONNECTION_PASSWORD_FILE): the password file
  * [ANSIBLE_BECOME_PASSWORD_FILE](https://docs.ansible.com/ansible/devel/reference_appendices/config.html#envvar-ANSIBLE_BECOME_PASSWORD_FILE): the become password file

The files are then automatically mounted into the [Docker container](ans-x-docker.md)


## Debug

### How to debug your private key 

* Get a shell in Ansible docker with [ans-x-shell](bin/ans-x-shell) 
```bash
ans-x-shell
```
* Try to connect to your host with your key and some verbosity. 
```bash
ssh -i $ANSIBLE_PRIVATE_KEY_FILE -vvv user@host
```

## Conf

### How to enable pass on demand?

You can enable pass on demand. See [pass](ans-x-pass.md).
