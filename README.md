# Ansible


## About
This directory contains `Ansible` cli [scripts](#script-list) that are located in the docker image [gerardnico/ansible:2.7](https://hub.docker.com/r/gerardnico/ansible/) build by this [Dockerfile](2.7/Dockerfile)


## Start Process

  * Clone the [gerardnico/ansible](https://github.com/gerardnico/ansible) repository 
  * [Optional] if you don't have access to Docker hub, build the image `gerardnico/ansible:x.x` with the [build.bat](build.bat) script
  * Add this directory to your `PATH` environment variable to be able to call the Ansible script from anywhere
  * Call the `ansible-xxx.cmd` cli scripts. See the [script section](#script-list) for a description
  


## How to

### Change the Ansible version

There is actually two image with the version:
  * 2.7
  * 2.8
By default, this is the latest that is used in the file [ansible-docker-run.cmd](ansible-docker-run.cmd)

You can set the env variable to another version if you want. Example:

```dos
SET ANSIBLE_VERSION = 2.7
```

### Works with Encrypted Private Key

When working with encrypted private key, Ansible will always ask the passphrase.
To overcome it for one session, you can call the [ansible-bash.cmd](ansible-bash.cmd) script, add your key and call all ansible cli from this session.

Example:
 
```dos 
ansible-bash
Starting the ssh-agent for convenience
Agent pid 7
Start the passed command (bash)
ansible@3240e859c2c6:/ansible/playbooks$ ssh-add privkey.pem
Enter passphrase for privkey.pem:
Identity added: privkey.pem (privkey.pem)
ansible@3240e859c2c6:/ansible/playbooks$
```

## Script list

Called from the Cmd shell

  * [ansible-bash.cmd](ansible-bash.cmd) - Get a bash shell inside the docker container where all Ansible cli can be started
  * [ansible-playbook.cmd](ansible-playbook.cmd) - The `ansible-playbook` cli
  * [ansible-inventory.cmd](ansible-inventory.cmd) - The `ansible-inventory` cli
  * [ansible-config.cmd](ansible-config.cmd) - The `ansible-config` cli
  * [ansible.cmd](ansible.cmd) - The Ansible cli
  * [ansible-pull.cmd](ansible-pull.cmd) - The [ansible-pull cli](https://docs.ansible.com/ansible/latest/cli/ansible-pull.html)
  * [ansible-vault.cmd](ansible-vault.cmd) - The [ansible-vault cli](https://docs.ansible.com/ansible/latest/user_guide/vault.html). !!! Warning, you can't use a password file, see [ansible-vault](#ansible-vault) !!!
  * [ansible-azure-rm.cmd](ansible-azure-rm.cmd) - The Azure Inventory script `azure_rm.py`
  * [build.bat](build.bat) - Build/Create the Ansible Docker image from the [Dockerfile](2.7/Dockerfile)

Called from inside the Docker container. You need to call the script [ansible-bash.cmd](ansible-bash.cmd) first.

  * [azure-inventory.sh](azure-inventory.sh) - A script to format the output of the Azure Inventory script from [ansible-azure-rm.cmd](ansible-azure-rm.cmd) or `azure_rm.py`
  * `azure_rm.py` -  the Azure Inventory script. Before, you need to copy [azure-conf-dist.cmd](azure-conf-dist.cmd) to `azure-conf.cmd` and set your identity variables

Called indirectly by the other scripts

  * [azure-conf-dist.cmd](azure-conf-dist.cmd) - A script that may be copied to `azure-conf.cmd` where the Azure identity parameters are stored
  * [ansible-docker-run.cmd](ansible-docker-run.cmd) - The base script that call `docker run`. All other script call this one to run docker. You never need to call it or to modify it.

## Note


### Ansible-vault

When running Docker on Windows, the default permission makes the files executable. See [Windows Permissions](#Windows Permissions)
You get this kind of errors:

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
and to use it in your command line

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

 
### Root

You can become `root` on this machine

```bash
sudo su -
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

### Ansible Package Repository

Personal Package Archives (PPAs) are developer repository. Developers create them in order to distribute their software. 
`ppa:ansible/ansible` is the PPA of Ansible.   

The repository location format is 

```
ppa:[username]/[ppaname]
```

The `Ansible` PPA is located at: https://launchpad.net/~ansible

The package `software-properties-common` install the following utility bin:
  
  * `/usr/bin/add-apt-repository`
  * `/usr/bin/apt-add-repository`

that helps manage the repository files located at:
  
  * `/etc/apt/sources.list`
  * `/etc/apt/sources.list.d`
  
 