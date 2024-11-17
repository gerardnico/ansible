# Ansible X Docker

## About

This page documentes the [Docker Image](https://github.com/gerardnico/ansible/pkgs/container/ansible)

## How to run

```bash
# get bash (same as ans-x-bash)
docker run --rm -it gerardnico/ansible:2.9 bash
# Run ansible-playbook cli
docker run --rm gerardnico/ansible:2.9 ansible-playbook --version
# Run ansible cli
docker run --rm gerardnico/ansible:2.9 ansible --version
```

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

## Security: User Al

The container runs with the user `al` (id: 1000, user: 1000)

Why ? The UID 1000 is assigned to first non-root user
and would be therefore the user that would run the scripts.

## How to pass environment variables to ansible 

We don't copy all envs to Docker to avoid secret leakage.

They are filtered by the expression defined by the environment variable `ANS_X_DOCKER_ENVS`
```bash
# ie accepts the env tha start with ANSIBLE, ACTION, AGNOS...
ANS_X_DOCKER_ENVS="^(ANSIBLE|ACTION|AGNOSTIC|ANY|BECOME|CACHE|CALLBACKS|COLLECTIONS|COLOR|CONNECTION|COVERAGE|DEFAULT|DEPRECATION|DEVEL|DIFF|DISPLAY|DOC|DUPLICATE|EDITOR|ENABLE|ERROR|FACTS_MODULES|GALAXY|HOST|INJECT|INTERPRETER|INVALID|INVENTORY|LOG|MAX_FILE_SIZE_FOR_DIFF|MODULE|HCLOUD|AZURE)"
```

The whole list can be found [here](https://docs.ansible.com/ansible/latest/reference_appendices/config.html)
If you want to add an env (for a plugin), you need to adjust this env. 

We allow [HCLOUD for Hetzner](https://docs.ansible.com/ansible/latest/collections/hetzner/hcloud/docsite/guides.html)

Note that if you want to give a qualified path as value, the working directory is:
* `/home/al` from 2.9
* `/ansible/playbooks` before 2.9

## Components

### Collection

The installation contains a lot of collection.

Example : [2.9 Collections](../Dockerfiles/2.9/README-2.9.md#collection)


### Kubernetes

The `kubectl` client is also installed.
(Needed by the [lookup plugin](../Dockerfiles/2.9/README-2.9.md#clients)


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
