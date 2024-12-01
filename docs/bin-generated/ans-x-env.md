% ans-x-env(1) Version Latest | Ansible X Execution Environment
# NAME

`ans-x-env` shows you the environment variables of the Ansible X Execution Environment.


# ENVS


## ANS_X_PROJECT_DIR
[The local ansible project directory to mount in docker](ANS_X_PROJECT_DIR_URL)
```bash
export ANS_X_PROJECT_DIR=/home/admin/code/ansible
```
# The location of a vault id in the pass secret manager
# This variable will set ANSIBLE_VAULT_PASSWORD_FILE
ANS_X_VAULT_ID_PASS=ansible/vault-password
# The location of a ssh key in the pass secret manager
# This variable will set ANSIBLE_PRIVATE_KEY_FILE
ANS_X_SSH_KEY_PASS=ssh-x/id_gerardnico_kube

# The SSH user password in pass
ANS_X_PASSWORD_PASS=

# The become password in pass
ANS_X_BECOME_PASSWORD_PASS=

# Do we load secret from pass (disabled for non-ssh cli such as molecule, ansible-config, ansible-galaxy, ... by default)
ANS_X_PASS_ENABLED=1

# The docker image namespace
ANS_X_DOCKER_NAMESPACE=gerardnico
# The docker image name
ANS_X_DOCKER_NAME=ansible
# The docker image tag
ANS_X_DOCKER_TAG=9.12.0
# The docker image registry
ANS_X_DOCKER_REGISTRY=ghcr.io
# A grep pattern expression that selects the environment variable to pass to Ansible
ANS_X_DOCKER_ENVS='^(ANS_X|ANSIBLE|ACTION|AGNOSTIC|ANY|BECOME|CACHE|CALLBACKS|COLLECTIONS|COLOR|CONNECTION|COVERAGE|DEFAULT|DEPRECATION|DEVEL|DIFF|DOC|DUPLICATE|EDITOR|ENABLE|ERROR|FACTS_MODULES|GALAXY|HOST|INJECT|INTERPRETER|INVALID|INVENTORY|LOG|MAX_FILE_SIZE_FOR_DIFF|MODULE|HCLOUD|AZURE)'

# Allocate a terminal to Docker and get colors
# Colors are extra characters. You need to set this variable to 0 to retrieve raw data in a script
ANS_X_DOCKER_TERMINAL='1'

# The project directory in the image (by default, the working directory)
ANS_X_DOCKER_IMAGE_PROJECT_DIR=/home/admin/code/ansible

# The ANSIBLE_HOME directory in the image
ANS_X_DOCKER_IMAGE_ANSIBLE_HOME=/ansible/home

# The shell in the image
# https://github.com/gerardnico/ansible-x/blob/main/docs/bin-generated/ans-x-shell.md#ANS_X_DOCKER_IMAGE_SHELL
ANS_X_DOCKER_IMAGE_SHELL='/usr/bin/env bash'


# Ansible Env that are mounted into the Ansible Docker Execution Environment

# Ansible Home: ANSIBLE_HOME (The directory where collections and roles are installed and searched by ansible)
# https://docs.ansible.com/ansible/latest/reference_appendices/config.html#ansible-home
ANSIBLE_HOME='/home/admin/.ansible'

# Ansible Collections Path: ANSIBLE_COLLECTIONS_PATH (The base collections directory)
# https://docs.ansible.com/ansible/latest/reference_appendices/config.html#collections-paths
ANSIBLE_COLLECTIONS_PATH=''

# Ansible Config. The path to the ansible.cfg config file
# https://docs.ansible.com/ansible/latest/reference_appendices/config.html#ansible-config
ANSIBLE_CONFIG=''

# Ansible Connection Path. The path to connection script
# https://docs.ansible.com/ansible/latest/reference_appendices/config.html#ansible-connection-path
ANSIBLE_CONNECTION_PATH=''

# Ansible cowsay path. Path. The custom cowsay path 
# https://docs.ansible.com/ansible/latest/reference_appendices/config.html#ansible-cow-path
ANSIBLE_COW_PATH=''

