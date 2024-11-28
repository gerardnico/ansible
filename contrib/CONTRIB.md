# CONTRIB


## User Docker Documentation
See [Dockerfile](../docs/ans-x-dockerfile.md)

## Dev Docker Documentation

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
