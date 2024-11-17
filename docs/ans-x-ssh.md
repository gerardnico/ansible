# How to connect with SSH?

## About

This page shows you how you can connect with SSH.

There are 2 methods:
* via [private key](#private-key-authentication-how-to-pass-a-private-key)
* via [password](#how-to-connect-with-a-password-authentication)


## Private Key Authentication: How to pass a private Key

### How to use a private key stored in Pass

We support passing a private key stored in the [pass secret manager](https://www.passwordstore.org/)

You need to set the variable `ANS_X_SSH_KEY_PASS` to the location of your private key

Example:
```bash
# if you get your key with
pass ansible/ssh-key
# you need to set ANS_X_SSH_KEY_PASS to
export ANS_X_SSH_KEY_PASS=ansible/ssh-key
```

When this variable is set, the ansible environment variable [ANSIBLE_PRIVATE_KEY_FILE](https://docs.ansible.com/ansible/devel/reference_appendices/config.html#envvar-ANSIBLE_PRIVATE_KEY_FILE)
is set.


### How to use a protected private keys stored in .ssh

Automatically, the [entrypoint](../Dockerfiles/2.9/ans-x-entrypoint.sh) can add the encrypted key automatically to
the `ssh-agent`

How it works?
For instance, you want to add the encrypted private key called `id_rsa`

* Copy this file to your SSH home directory
  * Linux: `~/.ssh`
  * Windows: `%USERPROFILE%/.ssh`
* Add the environment variable `ANS_X_SSH_KEY_PASSPHRASE_id_rsa` with the passphrase as value where:
  * `ANS_X_SSH_KEY_PASSPHRASE_` is a prefix
  * `id_rsa` is the name of the key
* Use any [wrapper shell script](../README.md#script-list)

```bash
ansible xxxxx
ansible-bash xxxxx
ansible-playbook xxxxx
```

### How to use a non-protected key stored in .ssh

You need to:
* set your private key in `~/.ssh`
* set the [ANSIBLE_PRIVATE_KEY_FILE](https://docs.ansible.com/ansible/devel/reference_appendices/config.html#envvar-ANSIBLE_PRIVATE_KEY_FILE) to the file name

Example:
```bash
export ANSIBLE_PRIVATE_KEY_FILE=my_key
```

### How to add manually a private key

Manually, you would:

* call the [ans-x-bash](bin/ans-x-bash.md) script,
* add your keys with `ssh-add`
* and call all ansible cli from this session.

Example:

* Get a shell in Ansible docker with [ans-x-bash](bin/ans-x-bash.md)
```bash
ans-x-bash
```
* Then
```bash
eval "$(ssh-agent -s)"
ssh-add privkey.pem
```

* Use any ansible command line tool

```bash
ansible xxxxx
ansible-playbook xxxxx
# xxx
```


## How to connect with a password authentication

### How to use a password stored in Pass

We support passing passwords stored in the [pass secret manager](https://www.passwordstore.org/)

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
* [ANSIBLE_CONNECTION_PASSWORD_FILE](https://docs.ansible.com/ansible/devel/reference_appendices/config.html#envvar-ANSIBLE_CONNECTION_PASSWORD_FILE)
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

* Get a shell in Ansible docker with [ans-x-bash](bin/ans-x-bash.md) 
```bash
ans-x-bash
```
* Try to connect to your host with your key and some verbosity. 
```bash
ssh -i $ANSIBLE_PRIVATE_KEY_FILE -vvv user@host
```
