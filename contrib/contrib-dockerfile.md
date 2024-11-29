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

* You can execute a `docker build` with [ans-x-docker-build](ans-x-docker-build) script.



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

## Ansible Version

We install the [ansible](https://pypi.org/project/ansible/) package.
The tag is the version of the [ansible](https://pypi.org/project/ansible/) package.

* The ansible-core python package contains the core runtime and CLI tools, such as:
    * ansible
    * and ansible-playbook
      while the [ansible](https://pypi.org/project/ansible/) package contains extra modules, plugins, and roles.

See the version relation here: https://docs.ansible.com/ansible/latest/reference_appendices/release_and_maintenance.html#ansible-community-changelogs

## Ansible Installation


We do not install anymore with [ppa](#deprecated---ansible-package-repository-ppa) over Ubuntu
because it's a pain in the ass to install other package that are not in the Ubuntu repo.
See [Python](#python)

### Ansible Development Tools


[Ansible Development Tools](https://ansible.readthedocs.io/projects/dev-tools/)
aims to streamline the setup and usage of several tools needed in order to create Ansible content.
It combines critical Ansible development packages into a unified Python package.

https://github.com/ansible/ansible-dev-tools
They also have a [Container](https://ansible.readthedocs.io/projects/dev-tools/container/#related-links)
```bash
docker pull ghcr.io/ansible/community-ansible-dev-tools:v24.11.0
```



## Deprecated
### Deprecated - Ansible Package Repository (PPA)

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




### Python

Install instructions are mostly with
```bash
python3 -m pip
```
They need a venv due to https://peps.python.org/pep-0668/

Otherwise running
```Dockerfile
RUN python3 -m pip install ansible-dev-tools
```
will get your
```
# Error
#× This environment is externally managed
#0.707 ╰─> To install Python packages system-wide, try apt install
#0.707     python3-xyz, where xyz is the package you are trying to
#0.707     install.
```

Pipx create a venv
```bash
pipx
```



