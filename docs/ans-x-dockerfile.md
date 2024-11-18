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

## Security: User Al

The container runs with the user `al` (id: 1000, user: 1000)

Why ? The UID 1000 is assigned to first non-root user
and would be therefore the user that would run the scripts.
