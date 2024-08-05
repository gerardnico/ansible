# Docker 2.9



## Version Control


There is only a 2.9 version (ie version 9) then the core is then a 2.16
See the relation here: https://docs.ansible.com/ansible/latest/reference_appendices/release_and_maintenance.html#ansible-community-changelogs

The python version needs to be 3.10 - 3.12
See the Matrix Support: https://docs.ansible.com/ansible/latest/reference_appendices/release_and_maintenance.html#ansible-core-support-matrix

Actual version inside the image is `2.16.8` with Python `3.12.3`

```bash
ansible --version
```
```
ansible [core 2.16.8]
    config file = /ansible/playbooks/ansible.cfg
    configured module search path = ['/ansible/playbooks/"ansible"/plugins/modules', '/usr/share/ansible/plugins/modules']
    ansible python module location = /usr/lib/python3/dist-packages/ansible
    ansible collection location = /ansible/playbooks/"ansible"/collections:/usr/share/ansible/collections
    executable location = /usr/bin/ansible
    python version = 3.12.3 (main, Apr 10 2024, 05:33:47) [GCC 13.2.0] (/usr/bin/python3)
    jinja version = 3.1.2
    libyaml = True
```

## Collection

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

## Clients

Lookup plugins needs client tools on the control node

The following clients are installed:
* `kubectl` for [kustomize_lookup](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/kustomize_lookup.html)