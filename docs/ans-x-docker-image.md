# Ans-X Docker Image

## About
The `Ans-x Docker Image` is the [default image](ans-x-docker.md#ans-x-image) used by the `ans-x scripts`.

It's an [Ansible Execution Environment](../contrib/contrib-ee)

The image is:
* hosted on Github at [Ans-x Docker Image](https://github.com/gerardnico/ansible/pkgs/container/ansible)
* created with this [Dockerfile](../contrib/contrib-dockerfile)

## Usage


* You can execute an ansible command
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

## Features

### Collection

The installation contains the [community collections](https://docs.ansible.com/ansible/latest/collections/index.html)

Get them with [ansible-galaxy](bin-generated/ansible-galaxy.md)

```bash
ansible-galaxy collection list
```


### Kubernetes

The `kubectl` client is also installed.
(Needed by the [lookup plugin](../Dockerfiles/2.9/README-9#clients)

### Ansible Dev Tool

The [Ansible Development Tools](https://ansible.readthedocs.io/projects/dev-tools/) are included.



