# Ansible


## About
This directory contains `Ansible` cli [scripts](#script-list) that are located 
in the docker image [gerardnico/ansible:xxx](https://hub.docker.com/r/gerardnico/ansible/) 
build by this [Dockerfile](./Dockerfiles)

## Run Example

After the image have been [build locally](build.bat), 
you can run and choose a version with:
```dos
SET ANSIBLE_VERSION=8
ansible-playbook --version
```


## Start Process

  * Clone the [gerardnico/ansible](https://github.com/gerardnico/ansible) repository 
  * [Optional] if you don't have access to Docker hub, build the image `gerardnico/ansible:x.x` with the [build.bat](build.bat) script
  * Add this directory to your `PATH` environment variable to be able to call the Ansible script from anywhere
  * Call the `ansible-xxx.cmd` DOS or `ansible-xxx` Posix cli scripts. See the [script section](#script-list) for a description


## How to

### Define a project location so that the commands can be run from anywhere

If you work in a project and don't want to `cd` into it every time to run
the ansible command, you can set the env variable `ANSIBLE_LOCAL_HOME` to the path
of you ansible project.

This directory will then be mounted and used instead of the current working directory.

### Change the Ansible version

There is actually 3 images with the version:
  * 2.7
  * 2.8
  * 2.9
By default, this is the latest that is used in the file [ansible-docker-run.cmd](ansible-docker-run.cmd)

You can set the env variable to another version if you want. Example:

```dos
SET ANSIBLE_VERSION=2.8
```

### Work with a client encrypted SSH Private Key


When working with encrypted private key, our entrypoint will start a `ssh-agent`.

You can then add the key:
* manually 
* or automatically via the setting of environment variables.


#### Add manually private key

Manually, you would:
* call the [ansible-bash.cmd](ansible-bash.cmd) script, 
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

Automatically, the [entrypoint](Dockerfiles/2.9/entrypoint.sh) can add the encrypted key automatically to the `ssh-agent`

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

## Script list

### DOS
Called from the Cmd shell

  * [ansible-bash.cmd](ansible-bash.cmd) - Get a bash shell inside the docker container where all Ansible cli can be started. Run the command with `sudo`
  * [ansible-playbook.cmd](ansible-playbook.cmd) - The `ansible-playbook` cli
  * [ansible-inventory.cmd](ansible-inventory.cmd) - The `ansible-inventory` cli
  * [ansible-config.cmd](ansible-config.cmd) - The `ansible-config` cli
  * [ansible.cmd](ansible.cmd) - The Ansible cli
  * [ansible-pull.cmd](ansible-pull.cmd) - The [ansible-pull cli](https://docs.ansible.com/ansible/latest/cli/ansible-pull.html)
  * [ansible-vault.cmd](ansible-vault.cmd) - The [ansible-vault cli](https://docs.ansible.com/ansible/latest/user_guide/vault.html). !!! Warning, on windows, you can't use a password file, see [ansible-vault](#on-windows-ansible-vault-id-should-be-an-executable-file) !!!
  * [ansible-azure-rm.cmd](ansible-azure-rm.cmd) - The Azure Inventory script `azure_rm.py`
  * [build.bat](build.bat) - Build/Create the Ansible Docker image from the [Dockerfile](Dockerfiles/8/Dockerfile)

Called from inside the Docker container. You need to call the script [ansible-bash.cmd](ansible-bash.cmd) first.

  * [azure-inventory.sh](azure_inventory.sh) - A script to format the output of the Azure Inventory script from [ansible-azure-rm.cmd](ansible-azure-rm.cmd) or `azure_rm.py`
  * `azure_rm.py` -  the Azure Inventory script. Before, you need to copy [azure-conf-dist.cmd](azure-conf-dist.cmd) to `azure-conf.cmd` and set your identity variables

Called indirectly by the other scripts

  * [azure-conf-dist.cmd](azure-conf-dist.cmd) - A script that may be copied to `azure-conf.cmd` where the Azure identity parameters are stored
  * [ansible-docker-run.cmd](ansible-docker-run.cmd) - The base script that call `docker run`. All other script call this one to run docker. You never need to call it or to modify it.

### POSIX (Cygwin)

  * [ansible](ansible)
  * [ansible-bash](ansible-bash)
  * [ansible-playbook](ansible-playbook)
  * [ansible-encrypt](ansible-encrypt)



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

### Support: SSH UNPROTECTED PRIVATE KEY FILE

2 tips: 
* Even if it can be seen as completely mad, this error can appear when the 
env variable `$ANSIBLE_CONFIG` is bad.
* Mounting the keys under the `%UserProfile%/.ssh` make the key only readable by owner. 


### Collection

The installation contains a lot of collection.

Example: [2.9 Collections](Dockerfiles/2.9/README-2.9.md#collection)

## Support

### On Windows, ansible-vault id should be an executable file

When running Docker on Windows, the default permission makes the files executable. See [Windows Permissions](#windows-permissions)
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