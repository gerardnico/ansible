# Ansible X - Easy Ansible Execution on Windows, Linux and Mac

## About

With this directory, you can run `Ansible` from any OS.

## Two mode of execution

### Via the docker image

With [Ansible Docker Image gerardnico/ansible:xxx](https://hub.docker.com/r/gerardnico/ansible/)

* you can execute an ansible command
```bash
docker run --rm ghcr.io/gerardnico/ansible:2.9 YOUR ANSIBLE COMMAND
# example
docker run --rm ghcr.io/gerardnico/ansible:2.9 ansible --version
```
* or you can get bash shell
```bash
docker run --rm -it ghcr.io/gerardnico/ansible:2.9 bash
# and execute the ansible command from the shell
ansible
```

### Via the companion scripts

With the [companion scripts](#script-list), you can call the ansible cli directly. 

Example:
```bash
ansible --version
```

## Features

### Docker

* [All collections preinstalled](docs/ans-x-docker#collection)
* [Kubernetes Ready](docs/ans-x-docker#kubernetes)

### Scripts Features

* [Handle SSH protected keys](docs/ans-x-ssh.md)
* [Project Directory: Run your command from any current directory](#define-the-ansible_local_home-env-project-location-so-that-the-commands-can-be-run-from-anywhere)
* [Scripts works on Windows/Linux/iOS](#ansible-scripts)

## Installation


### Manually

* Clone the [gerardnico/ansible](https://github.com/gerardnico/ansible) repository to install the [scripts](#script-list)
```bash
cd ~/code
git clone https://github.com/gerardnico/ansible.git
```
* On Linux, give them execution permissions
```bash
chmod +x bin/*
```
* Add this directory to your `PATH` environment variable to be able to call the [Ansible script](#ansible-scripts) from anywhere
```bash
export PATH=~/ansible/bin
```
* Run any [Ansible script](#ansible-scripts)
```bash
ansible-playbook --version
```
* Dos:
```dos
ansible-playbook --version
```


## How to

### Define the ANS_X_PROJECT_DIR env project location so that the commands can be run from anywhere

If you work in a project and don't want to `cd` into it every time to run
the ansible command, you can set the env variable `ANS_X_PROJECT_DIR` to the path
of you ansible project.

This directory will then be mounted and used instead of the current working directory.

### Change the Ansible version

There is actually 3 images with the version:

* 2.7
* 2.8
* 2.9
  By default, this is the latest 

You can set the env variable to another version if you want. Example:

* Linux, Windows WSL 
```bash
export ANS_X_ANSIBLE_VERSION=2.9
```
* Windows Dos
```dos
SET ANS_X_ANSIBLE_VERSION=2.9
```

### Work with a client encrypted SSH Private Key

See [How to define SSH keys](docs/ans-x-ssh.md)

## Script list

All scripts are available in:

* POSIX (WSL / Cygwin / Mac) written for `bash`
* Windows written for `Dos` (We recommend to use WSL on windows)

They are wrapper scripts that:
* lives in your laptop
* call the [Ansible Command line clients](https://docs.ansible.com/ansible/latest/command_guide/command_line_tools.html) in the Docker container
* have [extra features](#scripts-features) such as:
  * login
  * and project home.

### Ansible Scripts

These scripts are the counterpart of the [Ansible Command line clients](https://docs.ansible.com/ansible/latest/command_guide/command_line_tools.html).


| Bash (Linux / Windows WSL or Cygwin)       | Dos (Windows)                                    | Description                                                                                                                      |
|--------------------------------------------|--------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| [ansible](docs/bin-generated/ansible.md)   | [ansible.cmd](docs/bin-generated/ansible.md)                       | The Ansible cli                                                                                                                  |
| [ansible-playbook](bin/ansible-playbook)   | [ansible-playbook.cmd](bin/ansible-playbook.cmd)     | The `ansible-playbook` cli                                                                                                       |
| [ansible-inventory](bin/ansible-inventory) | [ansible-inventory.cmd](bin/ansible-inventory.cmd)   | The `ansible-inventory` cli                                                                                                      |
| [ansible-config](bin/ansible-config)       | [ansible-config.cmd](bin/ansible-config.cmd)         | The `ansible-config` cli                                                                                                         |
|                                            | [ansible-pull.cmd](bin/ansible-pull.cmd)             | The [ansible-pull cli](https://docs.ansible.com/ansible/latest/cli/ansible-pull.html)                                            |
| [ansible-vault](bin/ansible-vault)         | [ansible-vault.cmd](bin/ansible-vault.cmd)           | The [ansible-vault cli](https://docs.ansible.com/ansible/latest/user_guide/vault.html)                                           | 

### Ans-X Scripts

These scripts are utility scripts 

| Bash (Linux / Windows WSL or Cygwin) | Dos (Windows)                        | Description                                                                                                                      |
|--------------------------------------|--------------------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| [ans-x--bash](bin/ans-x-bash)        | [ans-x-bash.cmd](bin/ans-x-bash.cmd) | Get a bash shell inside the container where all Ansible cli can be started                                                       |
| [ans-x-encrypt](bin/ans-x-encrypt)   | [ans-x-encrypt](bin/ans-x-encrypt)   | An `ansible-vault encrypt_string` utility cli                                                                                    |
|  | [ansible-azure-rm.cmd](bin/ans-x-azure-rm.cmd) | The Azure Inventory script `azure_rm.py` |

### Azure Scripts

The scripts below needs to be called from inside the Docker container. You need to call the script [ansible-bash.cmd](bin/ans-x-bash.cmd) first.

* [azure-inventory.sh](bin/ans-x-azure-inventory) - A script to format the output of the Azure Inventory script
  from [ansible-azure-rm.cmd](bin/ans-x-azure-rm.cmd) or `azure_rm.py`
* `azure_rm.py` - the Azure Inventory script. Before, you need to copy [azure-conf-dist.cmd](bin/azure-conf-dist.cmd)
  to `azure-conf.cmd` and set your identity variables


* [azure-conf-dist.cmd](bin/azure-conf-dist.cmd) - A script that may be copied to `azure-conf.cmd` where the Azure identity
  parameters are stored


### Support: SSH UNPROTECTED PRIVATE KEY FILE

2 tips:

* Even if it can be seen as completely mad, this error can appear when the
  env variable `$ANSIBLE_CONFIG` is bad.
* Mounting the keys under the `%UserProfile%/.ssh` make the key only readable by owner.



## How to contribute

See [CONTRIB](contrib/CONTRIB.md)

## Support

### On Windows, ansible-vault id should be an executable file

When running Docker on Windows, the default permission makes the files executable in Docker.
See [Windows Permissions](#windows-permissions)
You get this kind of error:

```txt
[WARNING]: Error in vault password file loading (None): Problem running vault password script
/ansible/playbooks/vault_pwd_file.txt ([Errno 8] Exec format error). If this is not a script, remove the executable
bit from the file.
```

To resolve this problem, you need to create an executable file that will output your password:

```bash 
#!/usr/bin/env bash
echo myPassword
```

and to use it in your command line or set it in your `ansible.cfg` file

```dos
ansible-vault encrypt_string --vault-id vault_pwd_file.sh 'foobar' --name 'the_secret'
'the_secret': !vault |
          $ANSIBLE_VAULT;1.1;AES256
          39373333356435366461373363663939363837623530363061353461326365353832366363363439
          3665393437373663646561373762656439333365643334640a346236323639366637393937666134
          66653037326466663262626337616435396461646239316163666437356332363066333935376364
          3136333031616339370a323330373163333466396339343834653830356131316564626636663332
          3330
Encryption successful
```

### Windows Permissions

```txt
SECURITY WARNING: You are building a Docker image from Windows against a non-Windows Docker host. 
All files and directories added to build context will have '-rwxr-xr-x' permissions. 
It is recommended to double check and reset permissions for sensitive files and directories.
```

The Windows filesystem does not have an option to mark a file as `executable`.

Building a Linux image from a Windows machine would therefore break the image
if a file has to be marked executable.

For that reason, files are marked executable by default when building from a windows client.

You can modify the Dockerfile to change/remove the executable bit afterwards.