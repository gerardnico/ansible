# Ansible X Docker

## About

This page documentes the Docker Image.

## Component

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
