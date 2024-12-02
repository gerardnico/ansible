# Ansible eXpress (Ans-x) - Easy Ansible Execution (Windows, Linux, Mac, Docker) 

## About
Run any [Ansible cli](#ansible-scripts) in `2` steps.

* Install
```bash
brew install --HEAD gerardnico/tap/ansx
```
* Run
```bash
ansible --version
```

## Features

With `Ans-x`, you get:
* a [Docker Ansible Execution Environment](docs/ans-x-docker.md)
* a [full collection of Ansible scripts](#ans-x-scripts) that works [on Windows/Linux/iOS](#ansible-scripts)
* [SSH protected keys and password](docs/ans-x-ssh.md)
* a [Project Aware Execution](#how-to-define-a-project-location-so-that-the-commands-can-be-run-from-anywhere)
* support for [pass](docs/ans-x-pass.md) as secret store to get:
  * a [vault id](#how-to-encryptdecrypt-with-vault) 
  * an [ssh private key/password](docs/ans-x-ssh.md)
* Native [Ansible environments](docs/bin-generated/ans-x-env.md#ansible-env) injection for [ANSIBLE_HOME](docs/bin-generated/ans-x-env.md#ansible_home), [ANSIBLE_COLLECTIONS_PATH](docs/bin-generated/ans-x-env.md#ansible_collections_path), ...
* a [Kubernetes Ready Ansible](docs/ans-x-docker-image.md#kubernetes)
* the [Ansible Dev Tools packaged](docs/ans-x-docker-image.md#ansible-dev-tool)
* [Docker in Docker ready](#what-is-docker-in-docker-feature)


## Ans-X Scripts

All scripts are available in:

* POSIX (WSL / Cygwin / Mac) written for `bash`
* Windows written for `Dos` (Deprecated, on windows, we recommend [Windows Linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/))

They are wrapper scripts that:
* lives in your laptop
* call the [Ansible Command line clients](https://docs.ansible.com/ansible/latest/command_guide/command_line_tools.html) in the [Docker container](#how-to-define-the-ansible-docker-image)


### Ansible Core

These scripts are the counterpart of the [Ansible Core Command line clients](https://docs.ansible.com/ansible/latest/command_guide/command_line_tools.html).


| Bash (Linux / Windows WSL or Cygwin)                         | Dos (Windows)                                                    | Description                                                                            |
|--------------------------------------------------------------|------------------------------------------------------------------|----------------------------------------------------------------------------------------|
| [ansible](docs/bin-generated/ansible.md)                     | [ansible.cmd](docs/bin-generated/ansible.md)                     | The `ansible` cli runs a single task against a set of hosts                            |
| [ansible-config](docs/bin-generated/ansible-config.md)       | [ansible-config.cmd](docs/bin-generated/ansible-config.md)       | The `ansible-config` cli shows ansible configuration                                   |
| [ansible-galaxy](docs/bin-generated/ansible-galaxy.md)       | [ansible-galaxy.cmd](docs/bin-generated/ansible-galaxy.md)       | The `ansible-galaxy` cli executes role and Collection related operations               |
| [ansible-inventory](docs/bin-generated/ansible-inventory.md) | [ansible-inventory.cmd](docs/bin-generated/ansible-inventory.md) | The `ansible-inventory` cli  shows Ansible inventory information                       |
| [ansible-playbook](docs/bin-generated/ansible-playbook.md)   | [ansible-playbook.cmd](docs/bin-generated/ansible-inventory.md)  | The `ansible-playbook` cli runs Ansible playbooks                                      |
| [ansible-pull](docs/bin-generated/ansible-pull.md)           | [ansible-pull.cmd](docs/bin-generated/ansible-pull.md)           | The `ansible-pull` pulls and run playbooks from a VCS repo                             |
| [ansible-vault](docs/bin-generated/ansible-vault.md)         | [ansible-vault.cmd](docs/bin-generated/ansible-vault.md)                       | The [ansible-vault cli](https://docs.ansible.com/ansible/latest/user_guide/vault.html) | 
| [azure_rm](docs/bin-generated/azure_rm.md)                   | [azure_rm.cmd](docs/bin-generated/azure_rm.md)                   | The Azure Inventory script `azure_rm.py` (Deprecated, Old)                             |


### Ansible Dev Tools

These scripts are the counterpart of the [Ansible Dev Tools](https://ansible.readthedocs.io/projects/dev-tools/)


| Bash (Linux / Windows WSL or Cygwin)                         | Dos (Windows)                                                    | Description                                            |
|--------------------------------------------------------------|------------------------------------------------------------------|--------------------------------------------------------|
| [ansible-creator](docs/bin-generated/ansible-creator.md)     |  | Create collections quickly                             |
| [ansible-navigator](docs/bin-generated/ansible-navigator.md) |  | The `ansible-navigator` cli helps with troubleshooting |
| [molecule](docs/bin-generated/molecule.md)                   |                    | The Role Testing tool                                  |


### Ans-X Extra Scripts

These scripts are utility scripts 

| Bash (Linux / Windows WSL or Cygwin)                 | Dos (Windows)                                        | Description                                                                                                                      |
|------------------------------------------------------|------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------|
| [ans-x-shell](docs/bin-generated/ans-x-shell.md)     | [ans-x-shell.cmd](docs/bin-generated/ans-x-shell.md) | Get a shell inside the container where all Ansible cli can be started                                                       |
| [ans-x-encrypt](docs/bin-generated/ans-x-encrypt.md) | [ans-x-encrypt](docs/bin-generated/ans-x-encrypt.md) | An `ansible-vault encrypt_string` utility cli                                                                                    |



## How to

### How to define a project location so that the commands can be run from anywhere

See [How to define the Project Directory](docs/ans-x-project-directory.md)
 

### How to define the Ansible Docker Image?

By default, [ans-x scripts](#ans-x-scripts) executes the [ans-x docker image (Execution Environment)](docs/ans-x-docker-image.md).

This image has the following features:
* [All collections preinstalled](docs/ans-x-docker-image.md#collection)
* [Kubernetes Ready](docs/ans-x-docker-image.md#kubernetes)
* [Ansible Dev Tool included](docs/ans-x-docker-image.md#ansible-dev-tool)

You can define [another Ansible Image](docs/ans-x-docker.md#how-to-run-another-image)


### How to encrypt/decrypt with Vault

To be able to encrypt and decrypt, you need to set first a `passphrase` known as a `vault-it` in Ansible

You can do:
* from the [pass secret manager](docs/ans-x-pass.md)
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
* or use [ansible-vault](docs/bin-generated/ansible-vault.md) directly

### How to connect with SSH

See [How to define SSH key or password](docs/ans-x-ssh.md)

### How to use Ans-x in your script (disable terminal)?

See [How to use Ans-x in your script](docs/ans-x-script.md)

## FAQ

### What is Docker in Docker feature?

If you use [molecule](docs/bin-generated/molecule.md) to create test, you will create container
as test host. By default, a docker execution does not have this functionality.

We enable it by:
* mounting the docker socket and giving the right permissions.
* installing the docker cli (Mandatory for [molecule tasks](docs/bin-generated/molecule.md)) 

How can I test that my image is `docker in docker` enabled?
* Get a shell in the docker ansible image with [ans-x-shell.md](docs/bin-generated/ans-x-shell.md)
```bash
ans-x-shell
```
* Run docker command. 
```bash
docker ps
```
You should be able to see at minimum the ansible image where the shell is running. Example:
```
CONTAINER ID   IMAGE                               COMMAND                  CREATED         STATUS         PORTS     NAMES
a84f4740356d   ghcr.io/gerardnico/ansible:9.12.0   "/usr/bin/env bash -…"   3 seconds ago   Up 2 seconds             vigilant_gauss
```


## Installation

### HomeBrew

With [Homebrew](https://brew.sh/), you can install on Linux, Windows WSL or Mac

```bash
brew install --HEAD gerardnico/tap/ansx
```

### Manually

* Clone the [gerardnico/ansible](https://github.com/gerardnico/ansible) repository to install the [scripts](#ans-x-scripts)
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
* Run any [Ansible script](#ans-x-scripts) such as [ansible-playbook](docs/bin/ansible-playbook.md)
```bash
ansible-playbook --version
```

## How to contribute

See [CONTRIB](contrib/CONTRIB.md)