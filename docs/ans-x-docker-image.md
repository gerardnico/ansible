# Ans-X Docker Image

## About
The `Ans-x Docker Image` is the [default image](ans-x-docker.md#ans-x-image) used by the `ans-x scripts`.

The image is:
* hosted on Github at [Ans-x Docker Image](https://github.com/gerardnico/ansible/pkgs/container/ansible)
* created with this [Dockerfile](ans-x-dockerfile.md)

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

The installation contains a lot of collection.

Example : [2.9 Collections](../Dockerfiles/2.9/README-2.9.md#collection)


### Kubernetes

The `kubectl` client is also installed.
(Needed by the [lookup plugin](../Dockerfiles/2.9/README-2.9.md#clients)


