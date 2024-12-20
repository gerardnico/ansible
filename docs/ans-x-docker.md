# Ansible X Docker

## About

[Ans-x scripts](../README.md#ans-x-scripts) calls an Ansible execution environment 
(ie a ansible docker image serving as an Ansible control node)


## Which Ansible Image is used

### Ans-x Image

By default, [Ans-x scripts](../README.md#ans-x-scripts) run the [Ans-x Docker Image](https://github.com/gerardnico/ansible/pkgs/container/ansible)

The actual version is [9.12](https://pypi.org/project/ansible/9.12.0/).

```bash
# get bash (same as ans-x-bash)
docker run --rm -it ghcr.io/gerardnico/ansible:9.12 bash
# Run ansible-playbook cli
docker run --rm ghcr.io/gerardnico/ansible:9.12 ansible-playbook --version
# Run ansible cli
docker run --rm ghcr.io/gerardnico/ansible:9.12 ansible --version
```

### How to run another image

If you want to run another image, you need to set the following environment variables
```bash
export ANS_X_DOCKER_NAMESPACE=image-namespace
export ANS_X_DOCKER_NAME=image-name
export ANS_X_DOCKER_TAG=image-tag
export ANS_X_DOCKER_REGISTRY=docker.io # the image registry
```

`Ansible-X` needs also to know the following directories:
* `ANS_X_DOCKER_IMAGE_PROJECT_DIR`: the directory where to mount the [project directory](../README.md#how-to-define-a-project-location-so-that-the-commands-can-be-run-from-anywhere)
```bash
export ANS_X_DOCKER_IMAGE_PROJECT_DIR=/ansible/project 
```
* `ANS_X_DOCKER_IMAGE_ANSIBLE_HOME`: the directory where to mount [ANSIBLE_HOME](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#ansible-home)
```bash
export ANS_X_DOCKER_IMAGE_PROJECT_DIR=/ansible/home
```

#### How to use the official ansible dev-tools container? 

In this example, we use the [Ansible Community Devtools Container](https://ansible.readthedocs.io/projects/dev-tools/container/).

```bash
export ANS_X_DOCKER_NAMESPACE=ansible
export ANS_X_DOCKER_NAME=community-ansible-dev-tools
export ANS_X_DOCKER_TAG=v24.11.0
export ANS_X_DOCKER_REGISTRY=ghcr.io # the image registry
export ANS_X_DOCKER_IMAGE_PROJECT_DIR=/workdir/project
export ANS_X_DOCKER_IMAGE_PROJECT_DIR=/workdir/home
export ANS_X_DOCKER_IMAGE_SHELL="/usr/bin/env bash"
```

#### How to use a willhallonline container?

In this example, we use the [willhallonline 2.17-alpine-3.16](https://github.com/willhallonline/docker-ansible)

```bash
export ANS_X_DOCKER_NAMESPACE=willhallonline
export ANS_X_DOCKER_NAME=ansible
export ANS_X_DOCKER_TAG=2.17-alpine-3.16
export ANS_X_DOCKER_REGISTRY=docker.io # the image registry
export ANS_X_DOCKER_IMAGE_SHELL="/usr/bin/env sh" 
```
Bash does not exist in this image, you need to set `ANS_X_DOCKER_IMAGE_SHELL` 
so that [ans-x-shell](bin-generated/ans-x-shell.md) will work. 


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

## Qualified Path as env value

We mount the full path of all 
You should give a relatif path:
* from your current directory.
* of from your [project directory](../README.md#how-to-define-a-project-location-so-that-the-commands-can-be-run-from-anywhere)


