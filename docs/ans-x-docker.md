# Ansible X Docker

## About

[Ans-x scripts](../README.md#ans-x-scripts) uses a Docker image to run Ansible.


## Which Ansible Image is used

### Ans-x Image

By default, [Ans-x scripts](../README.md#ans-x-scripts) run the [Ans-x Docker Image](https://github.com/gerardnico/ansible/pkgs/container/ansible)


```bash
# get bash (same as ans-x-bash)
docker run --rm -it ghcr.io/gerardnico/ansible:2.9 bash
# Run ansible-playbook cli
docker run --rm ghcr.io/gerardnico/ansible:2.9 ansible-playbook --version
# Run ansible cli
docker run --rm ghcr.io/gerardnico/ansible:2.9 ansible --version
```

### How to run another image

If you want to run another image, you need to set the following environment variables
```bash
export ANS_X_DOCKER_NAMESPACE=image-namespace
export ANS_X_DOCKER_NAME=image-name
export ANS_X_DOCKER_TAG=image-tag
export ANS_X_DOCKER_REGISTRY=docker.io # the image registry
```

For instance, if you want to use the version [willhallonline 2.17-alpine-3.16](https://github.com/willhallonline/docker-ansible)

```bash
export ANS_X_DOCKER_NAMESPACE=willhallonline
export ANS_X_DOCKER_NAME=ansible
export ANS_X_DOCKER_TAG=2.17-alpine-3.16
export ANS_X_DOCKER_REGISTRY=docker.io # the image registry
```



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

Note that if you want to give a qualified path as value, the working directory on [ans-x image](#ans-x-image) is:
* `/home/al` from 2.9
* `/ansible/playbooks` before 2.9

