# How to connect with SSH?

## About

When working with encrypted private key, our entrypoint will start a `ssh-agent`.

You can then add the key:

* manually
* or automatically via the setting of environment variables.

## Private Key Authentication: How to pass a private Key

### Private key stored in Pass

We support passing a private key stored in the [pass secret manager](https://www.passwordstore.org/)

You need to set the variable `ANS_X_SSH_KEY_PASS` to the location of your private key

Example:
```bash
export ANS_X_SSH_KEY_PASS=ansible/ssh-key
```

When this variable is set, the ansible environment variable [ANSIBLE_PRIVATE_KEY_FILE](https://docs.ansible.com/ansible/devel/reference_appendices/config.html#envvar-ANSIBLE_PRIVATE_KEY_FILE)
is set



### Add manually a private key

Manually, you would:

* call the [ans-x-bash](bin/ans-x-bash.md) script,
* add your keys with `ssh-add`
* and call all ansible cli from this session.

Example:

* Get a shell in Ansible docker with [ans-x-bash](bin/ans-x-bash.md)
```bash
ans-x-bash
```

```
Starting the ssh-agent for convenience
Agent pid 7
Start the passed command (bash)
```

```bash
ssh-add privkey.pem
```

```
Enter passphrase for privkey.pem:
Identity added: privkey.pem (privkey.pem)
```

* Use any ansible command line tool

```bash
ansible xxxxx
ansible-playbook xxxxx
# xxx
```

## Add automatically private keys

Automatically, the [entrypoint](Dockerfiles/2.9/ansible-entrypoint.sh) can add the encrypted key automatically to
the `ssh-agent`

How it works?
For instance, you want to add the encrypted private key called `id_rsa`

* Copy this file to your SSH home directory
    * Linux: `~/.ssh`
    * Windows: `%USERPROFILE%/.ssh`
* Add the environment variable `ANSIBLE_SSH_KEY_PASSPHRASE_id_rsa` with the passphrase as value where:
    * `ANSIBLE_SSH_KEY_PASSPHRASE_id_` is a prefix
    * `id_rsa` is the name of the key
* Use any wrapper shell script

```bash
ansible xxxxx
ansible-bash xxxxx
ansible-playbook xxxxx
```


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
