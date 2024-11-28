# CONTRIB


## User Docker Documentation
See [Dockerfile](../docs/ans-x-dockerfile.md)

## Dev Docker Documentation

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
Not used for now.

[Ansible Development Tools](https://ansible.readthedocs.io/projects/dev-tools/)
aims to streamline the setup and usage of several tools needed in order to create Ansible content. It combines critical Ansible development packages into a unified Python package.

https://github.com/ansible/ansible-dev-tools
https://ansible.readthedocs.io/projects/dev-tools/container/#related-links
```bash
docker pull ghcr.io/ansible/community-ansible-dev-tools:v24.11.0
```

https://pipx.pypa.io/stable/#on-linux
https://pipx.pypa.io/stable/installation/#on-linux
