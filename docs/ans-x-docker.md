# Ansible X Docker

## About

This page documentes the [Docker Image](https://github.com/gerardnico/ansible/pkgs/container/ansible)

## Ansible version and DockerFiles

There is actually 3 Dockerfiles with the following version:

* [2.9](../Dockerfiles/2.9)
* [2.8](../Dockerfiles/2.8)
* [2.7](../Dockerfiles/2.7)

We host only the [latest on github](https://github.com/gerardnico/ansible/pkgs/container/ansible)
because Docker Hub does not update the README. 


## How to build and use an old version ?

If you want to use a precedent version, you need to build it.

Example:
```bash
docker build -t "gerardnico/ansible:2.8" "Dockerfiles/2.8"
```

You need then to set the env variable to another version. Example: Linux, Windows WSL
```bash
export ANS_X_ANSIBLE_VERSION=2.8
ansible --version
```


## Components

### Collection

The installation contains a lot of collection.

Example : [2.9 Collections](../Dockerfiles/2.9/README-2.9.md#collection)


### Kubernetes

The `kubectl` client is also installed.
(Needed by the [lookup plugin](../Dockerfiles/2.9/README-2.9.md#clients)


### Ansible Package Repository

We use PPA (Personal Package Archives (PPAs))

PPAs are developer repository. Developers create them in order to distribute their software.
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
