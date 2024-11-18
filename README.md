# Ansible X - Easy Ansible Execution on Windows, Linux and Mac

## About

With this directory, you can run `Ansible` from any OS.

## Two mode of executions

### Via the docker image

With [Ansible Docker Image gerardnico/ansible:xxx](docs/ans-x-docker.md)

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

### Scripts Features

* [Handle SSH protected keys](docs/ans-x-ssh.md)
* [Project Directory: Run your command from any current directory](#define-a-project-location-so-that-the-commands-can-be-run-from-anywhere)
* [Scripts works on Windows/Linux/iOS](#ansible-scripts)
* Support [pass](https://www.passwordstore.org/) as password manager to pass a [vault password](#encryptdecrypt) or an [ssh private key/password](docs/ans-x-ssh.md)

### Docker

* [All collections preinstalled](docs/ans-x-docker#collection)
* [Kubernetes Ready](docs/ans-x-docker#kubernetes)


## Installation

### HomeBrew

With [Homebrew](https://brew.sh/), you can install on Linux, Windows WSL or Mac

```bash
brew install --HEAD gerardnico/tap/ansx
```

### Manually

* Clone the [gerardnico/ansible](https://github.com/gerardnico/ansible) repository to install the [scripts](#script-list)
```bash
cd ~/code
git clone https://github.com/gerardnico/ansible-x.git
```
* Give them execution permissions and add the bin directory to your `PATH` environment variable to be able to call the [Ansible script](#ansible-scripts) from anywhere
```bash
chmod +x ~/code/ansible/bin/*
export PATH=~/code/ansible/bin:$PATH
```
* Clone the [gerardnico/bashlib](https://github.com/gerardnico/ansible) repository to install the library
```bash
cd ~/code
git clone https://github.com/gerardnico/bashlib.git
```
* Give the executable permission and add the library and bin directory to your `PATH` environment variable
```bash
chmod +x ~/code/bashlib/bin/*
export PATH=~/code/bashlib/lib:~/code/bashlib/bin:$PATH
```
* Run any [Ansible script](#script-list) such as [ansible-playbook](docs/bin/ansible-playbook.md)
```bash
ansible-playbook --version
```


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


| Bash (Linux / Windows WSL or Cygwin)                         | Dos (Windows)                                                    | Description                                                                                                                  |
|--------------------------------------------------------------|------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------|
| [ansible](docs/bin-generated/ansible.md)                     | [ansible.cmd](docs/bin-generated/ansible.md)                     | The `ansible` cli runs a single task against a set of hosts                                                                  |
| [ansible-config](docs/bin-generated/ansible-config.md)       | [ansible-config.cmd](docs/bin-generated/ansible-config.md)       | The `ansible-config` cli shows ansible configuration                                                                         |
| [ansible-galaxy](docs/bin-generated/ansible-galaxy.md)       | [ansible-galaxy.cmd](docs/bin-generated/ansible-galaxy.md)       | The `ansible-galaxy` cli execute role and Collection related operations                                                      |
| [ansible-inventory](docs/bin-generated/ansible-inventory.md) | [ansible-inventory.cmd](docs/bin-generated/ansible-inventory.md) | The `ansible-inventory` cli  show Ansible inventory information                                                              |
| [ansible-playbook](docs/bin-generated/ansible-playbook.md)   | [ansible-playbook.cmd](docs/bin-generated/ansible-inventory.md)  | The `ansible-playbook` cli runs Ansible playbooks                                                                            |
| [ansible-pull.cmd](docs/bin-generated/ansible-inventory.md)  | [ansible-pull.cmd](docs/bin-generated/ansible-inventory.md)      | The `ansible-pull` pulls and run playbooks from a VCS repo |
| [ansible-vault](bin/ansible-vault)                           | [ansible-vault.cmd](bin/ansible-vault.cmd)                       | The [ansible-vault cli](https://docs.ansible.com/ansible/latest/user_guide/vault.html)                                       | 
| [azure_rm](docs/bin-generated/azure_rm.md) | [azure_rm.cmd](docs/bin-generated/azure_rm.md)                   | The Azure Inventory script `azure_rm.py` |

### Ans-X Scripts

These scripts are utility scripts 

| Bash (Linux / Windows WSL or Cygwin) | Dos (Windows)                        | Description                                                                                                                      |
|--------------------------------------|--------------------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| [ans-x-bash](bin/ans-x-bash)        | [ans-x-bash.cmd](bin/ans-x-bash.cmd) | Get a bash shell inside the container where all Ansible cli can be started                                                       |
| [ans-x-encrypt](bin/ans-x-encrypt)   | [ans-x-encrypt](bin/ans-x-encrypt)   | An `ansible-vault encrypt_string` utility cli                                                                                    |



## How to

### Define a project location so that the commands can be run from anywhere

If you work in a project and don't want to `cd` into it every time to run
the ansible command, you can set the env variable `ANS_X_PROJECT_DIR` to the path
of you ansible project.

This directory will then be mounted and used instead of the current working directory.

Example:
```bash
export ANS_X_PROJECT_DIR=$HOME/my-ansible-project
```

### Encrypt/Decrypt

To be able to encrypt and decrypt, you need to set first a `passphrase` known as a `vault-it` in Ansible

You can do:
* from the [pass secret manager](https://www.passwordstore.org/)
```bash
# if you get your vault password with
pass ansible/vault-id
# you need to set ANS_X_VAULT_ID_PASS to
export ANS_X_VAULT_ID_PASS=ansible/vault-id
```
`Ans-x` will then create the [ANSIBLE_VAULT_PASSWORD_FILE](https://docs.ansible.com/ansible/devel/reference_appendices/config.html#envvar-ANSIBLE_VAULT_PASSWORD_FILE)
Otherwise, you can create it manually.

You can then:
* Encrypt: see [ans-x-encrypt](docs/bin/ans-x-encrypt.md)
* Decrypt: see [ans-x-decrypt](docs/bin/ans-x-decrypt.md)

### Connect with SSH 

See [How to define SSH keys or password](docs/ans-x-ssh.md)

## Support

### SSH UNPROTECTED PRIVATE KEY FILE

2 tips:

* Even if it can be seen as completely mad, this error can appear when the
  env variable `$ANSIBLE_CONFIG` is bad.
* Mounting the keys under the `%UserProfile%/.ssh` make the key only readable by owner.

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

## How to contribute

See [CONTRIB](contrib/CONTRIB.md)