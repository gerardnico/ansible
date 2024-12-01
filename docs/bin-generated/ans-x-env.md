% ans-x-env(1) Version Latest | Ansible X Execution Environment
# NAME

`ans-x-env` shows you the environment variables of the Ansible X Execution Environment.


# ENVS


## Ansible eXpress Env (Ans-x Env)
The Ansible Express Env

### ANS_X_PROJECT_DIR
[The local ansible project directory to mount in docker](https://github.com//gerardnico/ansible-x/blob/main/home/admin/code/ans-x-project-directory.md#ans_x_project_dir)
Mount the directory if set
```bash
export ANS_X_PROJECT_DIR=/home/admin/code/ansible
```

### ANS_X_VAULT_ID_PASS
[The location of a vault id in the pass secret manager](https://github.com//gerardnico/ansible-x/blob/main/home/admin/code/ansible/ansible-vault.md#ans_x_vault_id_pass)
This variable will set ANSIBLE_VAULT_PASSWORD_FILE
```bash
export ANS_X_VAULT_ID_PASS=ansible/vault-password
```

### ANS_X_SSH_KEY_PASS
[The location of a ssh key in the pass secret manager](https://github.com//gerardnico/ansible-x/blob/main/home/admin/code/ans-x-ssh.md#ans_x_ssh_key_pass)
This variable will set ANSIBLE_PRIVATE_KEY_FILE
```bash
export ANS_X_SSH_KEY_PASS=ssh-x/id_gerardnico_kube
```

### ANS_X_CONNECTION_PASSWORD_PASS
[The SSH user password in pass](https://github.com//gerardnico/ansible-x/blob/main/home/admin/code/ans-x-ssh.md#ans_x_connection_password_pass)
This variable will set ANSIBLE_CONNECTION_PASSWORD_FILE
```bash
export ANS_X_CONNECTION_PASSWORD_PASS=
```

### ANS_X_BECOME_PASSWORD_PASS
[The become password in pass](https://github.com//gerardnico/ansible-x/blob/main/home/admin/code/ans-x-ssh.md#ans_x_become_password_pass)
This variable will set ANSIBLE_BECOME_PASSWORD_FILE
```bash
export ANS_X_BECOME_PASSWORD_PASS=
```

### ANS_X_PASS_ENABLED
[Enable or disable the pass secret](https://github.com//gerardnico/ansible-x/blob/main/home/admin/code/ans-x-pass.md#ans_x_pass_enabled)
1 (default, enabled), 0 (disabled)
```bash
export ANS_X_PASS_ENABLED=1
```

### ANS_X_DOCKER_NAMESPACE
[The docker image namespace](https://github.com//gerardnico/ansible-x/blob/main/home/admin/code/ans-x-docker.md#ans_x_docker_namespace)
Set the namespace of the docker image used
```bash
export ANS_X_DOCKER_NAMESPACE=gerardnico
```

### ANS_X_DOCKER_NAME
[The docker image name](https://github.com//gerardnico/ansible-x/blob/main/home/admin/code/ans-x-docker.md#ans_x_docker_name)
Set the name of the docker image used
```bash
export ANS_X_DOCKER_NAME=ansible
```

### ANS_X_DOCKER_TAG
[The docker image tag](https://github.com//gerardnico/ansible-x/blob/main/home/admin/code/ans-x-docker.md#ans_x_docker_tag)
Set the tag of the docker image used
```bash
export ANS_X_DOCKER_TAG=9.12.0
```

### ANS_X_DOCKER_REGISTRY
[The docker image registry](https://github.com//gerardnico/ansible-x/blob/main/home/admin/code/ans-x-docker.md#ans_x_docker_registry)
Set the registry of the docker image used
```bash
export ANS_X_DOCKER_REGISTRY=ghcr.io
```

### ANS_X_DOCKER_ENVS
[The docker envs grep pattern expression](https://github.com//gerardnico/ansible-x/blob/main/home/admin/code/ans-x-docker.md#ans_x_docker_envs)
Selects the environment variable to pass to Ansible
```bash
export ANS_X_DOCKER_ENVS=^(ANS_X|ANSIBLE|ACTION|AGNOSTIC|ANY|BECOME|CACHE|CALLBACKS|COLLECTIONS|COLOR|CONNECTION|COVERAGE|DEFAULT|DEPRECATION|DEVEL|DIFF|DOC|DUPLICATE|EDITOR|ENABLE|ERROR|FACTS_MODULES|GALAXY|HOST|INJECT|INTERPRETER|INVALID|INVENTORY|LOG|MAX_FILE_SIZE_FOR_DIFF|MODULE|HCLOUD|AZURE)
```

### ANS_X_DOCKER_TERMINAL
[Allocate a terminal to Docker and get colors](https://github.com//gerardnico/ansible-x/blob/main/home/admin/code/ans-x-script.md#ans_x_docker_terminal)
Colors are extra characters. You need to set this variable to 0 to retrieve raw data in a script
```bash
export ANS_X_DOCKER_TERMINAL=1
```

### ANS_X_DOCKER_IMAGE_SHELL
[The shell in the docker image](https://github.com//gerardnico/ansible-x/blob/main/home/admin/code/ansible/ans-x-shell.md#ans_x_docker_image_shell)
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

