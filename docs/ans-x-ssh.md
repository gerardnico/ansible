# How to pass private key to Ansible X script?

## About

When working with encrypted private key, our entrypoint will start a `ssh-agent`.

You can then add the key:

* manually
* or automatically via the setting of environment variables.

#### Add manually a private key

Manually, you would:

* call the [ansible-bash.cmd](bin/ansible-bash.cmd) script,
* add your keys with `ssh-add`
* and call all ansible cli from this session.

Example:

```dos 
ansible-bash
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

#### Add automatically private keys

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