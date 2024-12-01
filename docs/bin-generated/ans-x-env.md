% ans-x-env(1) Version Latest | Ansible X Execution Environment
# NAME

`ans-x-env` shows you the environment variables of the Ansible X Execution Environment.


# ENVS


## Ansible eXpress Env (Ans-x Env)
The Ansible Express Env

### ANS_X_PROJECT_DIR
[The local ansible project directory to mount in docker](../ans-x-project-directory.md)
Mount the directory if set
```bash
export ANS_X_PROJECT_DIR=/home/admin/code/ansible
```

### ANS_X_VAULT_ID_PASS
[The location of a vault id in the pass secret manager](ansible-vault.md)
This variable will set ANSIBLE_VAULT_PASSWORD_FILE
```bash
export ANS_X_VAULT_ID_PASS=ansible/vault-password
```

### ANS_X_SSH_KEY_PASS
[The location of a ssh key in the pass secret manager](../ans-x-ssh.md)
This variable will set ANSIBLE_PRIVATE_KEY_FILE
```bash
export ANS_X_SSH_KEY_PASS=ssh-x/id_gerardnico_kube
```

### ANS_X_CONNECTION_PASSWORD_PASS
[The SSH user password in pass](../ans-x-ssh.md)
This variable will set ANSIBLE_CONNECTION_PASSWORD_FILE
```bash
export ANS_X_CONNECTION_PASSWORD_PASS=
```

### ANS_X_BECOME_PASSWORD_PASS
[The become password in pass](../ans-x-ssh.md)
This variable will set ANSIBLE_BECOME_PASSWORD_FILE
```bash
export ANS_X_BECOME_PASSWORD_PASS=
```

### ANS_X_PASS_ENABLED
[Enable or disable the pass secret](../ans-x-pass.md)
1 (default, enabled), 0 (disabled)
```bash
export ANS_X_PASS_ENABLED=1
```

### ANS_X_DOCKER_NAMESPACE
[The docker image namespace](../ans-x-docker.md)
Set the namespace of the docker image used
```bash
export ANS_X_DOCKER_NAMESPACE=gerardnico
```

### ANS_X_DOCKER_NAME
[The docker image name](../ans-x-docker.md)
Set the name of the docker image used
```bash
export ANS_X_DOCKER_NAME=ansible
```

### ANS_X_DOCKER_TAG
[The docker image tag](../ans-x-docker.md)
Set the tag of the docker image used
```bash
export ANS_X_DOCKER_TAG=9.12.0
```

### ANS_X_DOCKER_REGISTRY
[The docker image registry](../ans-x-docker.md)
Set the registry of the docker image used
```bash
export ANS_X_DOCKER_REGISTRY=ghcr.io
```

### ANS_X_DOCKER_ENVS
[The docker envs grep pattern expression](../ans-x-docker.md)
Selects the environment variable to pass to Ansible
```bash
export ANS_X_DOCKER_ENVS=^(ANS_X|ANSIBLE|ACTION|AGNOSTIC|ANY|BECOME|CACHE|CALLBACKS|COLLECTIONS|COLOR|CONNECTION|COVERAGE|DEFAULT|DEPRECATION|DEVEL|DIFF|DOC|DUPLICATE|EDITOR|ENABLE|ERROR|FACTS_MODULES|GALAXY|HOST|INJECT|INTERPRETER|INVALID|INVENTORY|LOG|MAX_FILE_SIZE_FOR_DIFF|MODULE|HCLOUD|AZURE)
```

### ANS_X_DOCKER_TERMINAL
[Allocate a terminal to Docker and get colors](../ans-x-script.md)
Colors are extra characters. You need to set this variable to 0 to retrieve raw data in a script
```bash
export ANS_X_DOCKER_TERMINAL=1
```

### ANS_X_DOCKER_IMAGE_SHELL
[The shell in the docker image](ans-x-shell.md)
Used by the ans-x-shell script
```bash
export ANS_X_DOCKER_IMAGE_SHELL=/usr/bin/env bash
```

## Ansible Env
The Ansible Env directory or file that are mounted into the Ansible Docker Execution Environment

### ANSIBLE_HOME
[Ansible Home](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#ansible-home)
The directory where resources such as collections and roles are installed and searched by ansible)
```bash
export ANSIBLE_HOME=/home/admin/.ansible
```

### ANSIBLE_COLLECTIONS_PATH
[Ansible Collections Path](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#collections-paths)
The base collections directory
```bash
export ANSIBLE_COLLECTIONS_PATH=
```

### ANSIBLE_CONFIG
[Ansible Config](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#ansible-config)
The path to the ansible.cfg config file
```bash
export ANSIBLE_CONFIG=
```

### ANSIBLE_CONNECTION_PATH
[ Ansible Connection Path](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#ansible-connection-path)
The path to connection script
```bash
export ANSIBLE_CONNECTION_PATH=
```

### ANSIBLE_COW_PATH
[Ansible cowsay path](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#ansible-cow-path)
The custom cowsay path
```bash
export ANSIBLE_COW_PATH=
```

