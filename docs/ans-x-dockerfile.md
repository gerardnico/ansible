# DockerFiles

## About
There is one Dockerfile by Ansible version at [Dockerfiles](../Dockerfiles)

There is actually 3 Dockerfiles with the following version:

* [2.9](../Dockerfiles/2.9)
* [2.8](../Dockerfiles/2.8)
* [2.7](../Dockerfiles/2.7)

We host only the [latest on github](https://github.com/gerardnico/ansible/pkgs/container/ansible)
because Docker Hub does not update the README.

## Dockerfile Build

* We work with [dock-x](https://github.com/gerardnico/dock-x) to run Docker command.

* The docker image properties are set in [](../.envrc)

* You can execute a `docker build` with [ans-x-docker-build](../contrib/ans-x-docker-build) script.



## How to build and use an old version ?

If you want to use a precedent version, you need to build it.

Example:
```bash
docker build -t "gerardnico/ansible:2.8" "Dockerfiles/2.8"
```

You need then to set the env variable to another version. Example: Linux, Windows WSL
```bash
export ANS_X_DOCKER_TAG=2.8
ansible --version
```

## Security: User 

The container runs as the host user.

## Ansible Installation

We install:
* ansible via [ppa](#ansible-package-repository-ppa) over Ubuntu
* [DevTool](#ansible-development-tools) via pipx

### Base Image

We started with Ubuntu due to the Ansible Installation doc.

But we could just reuse the [Ansible-development-tools](#ansible-development-tools) container
as base container and install tool such as `kubectl` over.

### Ansible Package Repository (PPA)

We use PPA (Personal Package Archives (PPAs))
as this is the Ansible way of [installing Ansible on Ubuntu](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu)


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


### Ansible Development Tools


[Ansible Development Tools](https://ansible.readthedocs.io/projects/dev-tools/)
aims to streamline the setup and usage of several tools needed in order to create Ansible content.
It combines critical Ansible development packages into a unified Python package.

https://github.com/ansible/ansible-dev-tools
[Container](https://ansible.readthedocs.io/projects/dev-tools/container/#related-links)
```bash
docker pull ghcr.io/ansible/community-ansible-dev-tools:v24.11.0
```

Installation is done via pipx but
https://github.com/pypa/pipx/discussions/1341
https://github.com/pypa/pipx/issues/1337
https://github.com/pypa/pipx/issues/754

https://pipx.pypa.io/stable/#on-linux
https://pipx.pypa.io/stable/installation/#on-linux




