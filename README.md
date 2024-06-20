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
  * Call the `ansible-xxx.cmd` cli scripts. See the [script section](#script-list) for a description
  

## How to

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

### Works with Encrypted Private Key

When working with encrypted private key, Ansible will always ask the passphrase.
To overcome it for one session, you can call the [ansible-bash.cmd](ansible-bash.cmd) script, add your key and call all ansible cli from this session.

Example:
 
```dos 
ansible-bash
```
```
Starting the ssh-agent for convenience
Agent pid 7
Start the passed command (bash)
ansible@3240e859c2c6:/ansible/playbooks$ ssh-add privkey.pem
Enter passphrase for privkey.pem:
Identity added: privkey.pem (privkey.pem)
```
```bash
sudo ansible xxxxx
```

## Script list

Called from the Cmd shell

  * [ansible-bash.cmd](ansible-bash.cmd) - Get a bash shell inside the docker container where all Ansible cli can be started. Run the command with `sudo`
  * [ansible-playbook.cmd](ansible-playbook.cmd) - The `ansible-playbook` cli
  * [ansible-inventory.cmd](ansible-inventory.cmd) - The `ansible-inventory` cli
  * [ansible-config.cmd](ansible-config.cmd) - The `ansible-config` cli
  * [ansible.cmd](ansible.cmd) - The Ansible cli
  * [ansible-pull.cmd](ansible-pull.cmd) - The [ansible-pull cli](https://docs.ansible.com/ansible/latest/cli/ansible-pull.html)
  * [ansible-vault.cmd](ansible-vault.cmd) - The [ansible-vault cli](https://docs.ansible.com/ansible/latest/user_guide/vault.html). !!! Warning, you can't use a password file, see [ansible-vault](#ansible-vault) !!!
  * [ansible-azure-rm.cmd](ansible-azure-rm.cmd) - The Azure Inventory script `azure_rm.py`
  * [build.bat](build.bat) - Build/Create the Ansible Docker image from the [Dockerfile](Dockerfiles/8/Dockerfile)

Called from inside the Docker container. You need to call the script [ansible-bash.cmd](ansible-bash.cmd) first.

  * [azure-inventory.sh](azure_inventory.sh) - A script to format the output of the Azure Inventory script from [ansible-azure-rm.cmd](ansible-azure-rm.cmd) or `azure_rm.py`
  * `azure_rm.py` -  the Azure Inventory script. Before, you need to copy [azure-conf-dist.cmd](azure-conf-dist.cmd) to `azure-conf.cmd` and set your identity variables

Called indirectly by the other scripts

  * [azure-conf-dist.cmd](azure-conf-dist.cmd) - A script that may be copied to `azure-conf.cmd` where the Azure identity parameters are stored
  * [ansible-docker-run.cmd](ansible-docker-run.cmd) - The base script that call `docker run`. All other script call this one to run docker. You never need to call it or to modify it.

## Note


### Ansible-vault

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
sudo ansible-xxx
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

### Support: SSH UNPROTECTED PRIVATE KEY FILE

2 tips: 
* Even if it can be seen as completely mad, this error can appear when the 
env variable `$ANSIBLE_CONFIG` is bad.
* Mounting the keys under the `%UserProfile%/.ssh` make the key only readable by owner. 


### Collection

The [last ansible 2.9](./Dockerfiles/2.9) contains the following collection:

```bash
ansible-galaxy collection list
```

Collection                               Version
---------------------------------------- -------
amazon.aws                               7.6.0
ansible.netcommon                        5.3.0
ansible.posix                            1.5.4
ansible.utils                            2.12.0
ansible.windows                          2.3.0
arista.eos                               6.2.2
awx.awx                                  23.9.0
azure.azcollection                       1.19.0
check_point.mgmt                         5.2.3
chocolatey.chocolatey                    1.5.1
cisco.aci                                2.9.0
cisco.asa                                4.0.3
cisco.dnac                               6.13.3
cisco.intersight                         2.0.9
cisco.ios                                5.3.0
cisco.iosxr                              6.1.1
cisco.ise                                2.9.1
cisco.meraki                             2.18.1
cisco.mso                                2.6.0
cisco.nxos                               5.3.0
cisco.ucs                                1.10.0
cloud.common                             2.1.4
cloudscale_ch.cloud                      2.3.1
community.aws                            7.2.0
community.azure                          2.0.0
community.ciscosmb                       1.0.9
community.crypto                         2.20.0
community.digitalocean                   1.26.0
community.dns                            2.9.1
community.docker                         3.10.1
community.general                        8.6.1
community.grafana                        1.8.0
community.hashi_vault                    6.2.0
community.hrobot                         1.9.2
community.library_inventory_filtering_v1 1.0.1
community.libvirt                        1.3.0
community.mongodb                        1.7.4
community.mysql                          3.9.0
community.network                        5.0.2
community.okd                            2.3.0
community.postgresql                     3.4.1
community.proxysql                       1.5.1
community.rabbitmq                       1.3.0
community.routeros                       2.15.0
community.sap                            2.0.0
community.sap_libs                       1.4.2
community.sops                           1.6.7
community.vmware                         4.4.0
community.windows                        2.2.0
community.zabbix                         2.4.0
containers.podman                        1.13.0
cyberark.conjur                          1.2.2
cyberark.pas                             1.0.25
dellemc.enterprise_sonic                 2.4.0
dellemc.openmanage                       8.7.0
dellemc.powerflex                        2.4.0
dellemc.unity                            1.7.1
f5networks.f5_modules                    1.28.0
fortinet.fortimanager                    2.5.0
fortinet.fortios                         2.3.6
frr.frr                                  2.0.2
gluster.gluster                          1.0.2
google.cloud                             1.3.0
grafana.grafana                          2.2.5
hetzner.hcloud                           2.5.0
hpe.nimble                               1.1.4
ibm.qradar                               2.1.0
ibm.spectrum_virtualize                  2.0.0
ibm.storage_virtualize                   2.3.1
infinidat.infinibox                      1.4.5
infoblox.nios_modules                    1.6.1
inspur.ispim                             2.2.2
inspur.sm                                2.3.0
junipernetworks.junos                    5.3.1
kaytus.ksmanage                          1.2.2
kubernetes.core                          2.4.2
lowlydba.sqlserver                       2.3.2
microsoft.ad                             1.5.0
netapp.aws                               21.7.1
netapp.azure                             21.10.1
netapp.cloudmanager                      21.22.1
netapp.elementsw                         21.7.0
netapp.ontap                             22.11.0
netapp.storagegrid                       21.12.0
netapp.um_info                           21.8.1
netapp_eseries.santricity                1.4.0
netbox.netbox                            3.18.0
ngine_io.cloudstack                      2.3.0
ngine_io.exoscale                        1.1.0
openstack.cloud                          2.2.0
openvswitch.openvswitch                  2.1.1
ovirt.ovirt                              3.2.0
purestorage.flasharray                   1.28.0
purestorage.flashblade                   1.17.0
purestorage.fusion                       1.6.1
sensu.sensu_go                           1.14.0
splunk.es                                2.1.2
t_systems_mms.icinga_director            2.0.1
telekom_mms.icinga_director              1.35.0
theforeman.foreman                       3.15.0
vmware.vmware_rest                       2.3.1
vultr.cloud                              1.12.1
vyos.vyos                                4.1.0
wti.remote                               1.0.5
