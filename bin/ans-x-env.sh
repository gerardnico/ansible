
# Don't load `$HOME/.bashenv.d/ans-x.sh`
# If we want to get another local environment
# We don't want to load the default env
# For instance, if ANS_X_PROJECT_DIR is set and that we have other
# ansible project, we may want to override this env.


# ANS_X_PROJECT_DIR
ANS_X_PROJECT_DIR=${ANS_X_PROJECT_DIR:-$PWD}
if [ ! -d "$ANS_X_PROJECT_DIR" ]; then
    echo_err "The local ansible project home directory ($ANS_X_PROJECT_DIR) of the ANS_X_PROJECT_DIR variable does not exist. Are you sure that your ansible project is located there?"
    exit 1;
fi
if [[ $(uname -a) =~ "CYGWIN" ]]; then
    # Cygwin to Docker Pwd format (ie --volume /c/current/workdir/from/host:/ansible/playbooks)
    # Note: Deleting the c part seems to work also (ie HOMEPATH=\Users\ngera)
    ANS_X_PROJECT_DIR=$(cygpath -aw "$ANS_X_PROJECT_DIR" | tr 'C:' '/c' | tr '\\' '/')
fi
echo "# The local ansible project directory to mount in docker"
echo "ANS_X_PROJECT_DIR=$ANS_X_PROJECT_DIR"

##################################
# Pass
##################################

# ANS_X_VAULT_ID_PASS
ANS_X_VAULT_ID_PASS=${ANS_X_VAULT_ID_PASS:-}
echo "# The location of a vault id in the pass secret manager"
echo "# This variable will set ANSIBLE_VAULT_PASSWORD_FILE"
echo "ANS_X_VAULT_ID_PASS=$ANS_X_VAULT_ID_PASS"

# ANS_X_SSH_KEY_PASS
ANS_X_SSH_KEY_PASS=${ANS_X_SSH_KEY_PASS:-}
echo "# The location of a ssh key in the pass secret manager"
echo "# This variable will set ANSIBLE_PRIVATE_KEY_FILE"
echo "ANS_X_SSH_KEY_PASS=$ANS_X_SSH_KEY_PASS"
echo ""

# ANS_X_PASSWORD_PASS
ANS_X_PASSWORD_PASS=${ANS_X_PASSWORD_PASS:-}
echo "# The SSH user password in pass"
echo "ANS_X_PASSWORD_PASS=$ANS_X_PASSWORD_PASS"
echo ""

# ANS_X_BECOME_PASSWORD_PASS
ANS_X_BECOME_PASSWORD_PASS=${ANS_X_BECOME_PASSWORD_PASS:-}
echo "# The become password in pass"
echo "ANS_X_BECOME_PASSWORD_PASS=$ANS_X_BECOME_PASSWORD_PASS"
echo ""

# ANS_X_PASS_ENABLED
LOAD_PASS_DEFAULT=$([ "$(basename "$0")" != "molecule" ] && echo "1" || echo "0")
ANS_X_PASS_ENABLED=${ANS_X_PASS_ENABLED:-$LOAD_PASS_DEFAULT}
# With molecule we don't need to have secret as we connect locally
echo "# Do we load secret from pass (disabled for molecule by default)"
echo "ANS_X_PASS_ENABLED=$ANS_X_PASS_ENABLED"
echo ""

##################################
# Docker
##################################
# ANS_X_DOCKER_NAMESPACE
ANS_X_DOCKER_NAMESPACE=${ANS_X_DOCKER_NAMESPACE:-gerardnico}
echo "# The docker image namespace"
echo "ANS_X_DOCKER_NAMESPACE=$ANS_X_DOCKER_NAMESPACE"

# ANS_X_DOCKER_NAME
ANS_X_DOCKER_NAME=${ANS_X_DOCKER_NAME:-ansible}
echo "# The docker image name"
echo "ANS_X_DOCKER_NAME=$ANS_X_DOCKER_NAME"

# ANS_X_DOCKER_TAG
ANS_X_DOCKER_TAG=${ANS_X_DOCKER_TAG:-9.12.0}
echo "# The docker image tag"
echo "ANS_X_DOCKER_TAG=$ANS_X_DOCKER_TAG"

# ANS_X_DOCKER_REGISTRY
ANS_X_DOCKER_REGISTRY=${ANS_X_DOCKER_REGISTRY:-"ghcr.io"}
echo "# The docker image registry"
echo "ANS_X_DOCKER_REGISTRY=$ANS_X_DOCKER_REGISTRY"



# ANS_X_DOCKER_ENVS
echo "# A grep pattern expression that selects the environment variable to pass to Ansible"
ANS_X_DOCKER_ENVS="^(ANS_X|ANSIBLE|ACTION|AGNOSTIC|ANY|BECOME|CACHE|CALLBACKS|COLLECTIONS|COLOR|CONNECTION|COVERAGE|DEFAULT|DEPRECATION|DEVEL|DIFF|DOC|DUPLICATE|EDITOR|ENABLE|ERROR|FACTS_MODULES|GALAXY|HOST|INJECT|INTERPRETER|INVALID|INVENTORY|LOG|MAX_FILE_SIZE_FOR_DIFF|MODULE|HCLOUD|AZURE)"
echo "ANS_X_DOCKER_ENVS='$ANS_X_DOCKER_ENVS'"
echo ""

# ANS_X_DOCKER_TERMINAL
echo "# Allocate a terminal to Docker and get colors"
echo "# Colors are extra characters. You need to set this variable to 0 to retrieve raw data in a script"
ANS_X_DOCKER_TERMINAL="${ANS_X_DOCKER_TERMINAL:-"1"}"
echo "ANS_X_DOCKER_TERMINAL='$ANS_X_DOCKER_TERMINAL'"
echo ""

# ANS_X_DOCKER_IMAGE_PROJECT_DIR
ANS_X_DOCKER_IMAGE_PROJECT_DIR=${ANS_X_DOCKER_IMAGE_PROJECT_DIR:-"$PWD"}
#if [ "$ANS_X_DOCKER_IMAGE_PROJECT_DIR" == "" ]; then
#  if [[ "$ANS_X_DOCKER_TAG" =~ "2.8"|"2.7" ]]; then
#    ANS_X_DOCKER_IMAGE_PROJECT_DIR="/ansible/playbook"
#  else
#    ANS_X_DOCKER_IMAGE_PROJECT_DIR="/ansible/project"
#  fi
#fi
echo "# The project directory in the image (by default, the working directory)"
echo "ANS_X_DOCKER_IMAGE_PROJECT_DIR=$ANS_X_DOCKER_IMAGE_PROJECT_DIR"
echo ""

# ANS_X_DOCKER_IMAGE_ANSIBLE_HOME
ANS_X_DOCKER_IMAGE_ANSIBLE_HOME=${ANS_X_DOCKER_IMAGE_ANSIBLE_HOME:-"/ansible/home"}
echo "# The ANSIBLE_HOME directory in the image"
echo "ANS_X_DOCKER_IMAGE_ANSIBLE_HOME=$ANS_X_DOCKER_IMAGE_ANSIBLE_HOME"
echo ""

# ANS_X_DOCKER_IMAGE_SHELL
ANS_X_DOCKER_IMAGE_SHELL="${ANS_X_DOCKER_IMAGE_SHELL:-"/usr/bin/env bash"}"
echo "# The shell in the image"
echo "ANS_X_DOCKER_IMAGE_SHELL='$ANS_X_DOCKER_IMAGE_SHELL'"
echo ""


# Ansible

# Ansible HOME
# We set it so that it's not empty and defined to the Ansible default because we mount it
echo "# Ansible Home: ANSIBLE_HOME (The directory where collections and roles are installed and searched by ansible)"
echo "# "
ANSIBLE_HOME=${ANSIBLE_HOME:-"$HOME/.ansible"}
echo "ANSIBLE_HOME='$ANSIBLE_HOME'"
echo ""

# Ansible Collections path
ANSIBLE_COLLECTIONS_PATH=${ANSIBLE_COLLECTIONS_PATH:-}
if [ "$ANSIBLE_COLLECTIONS_PATH" == "" ]; then
  # may be called ANSIBLE_COLLECTIONS_PATHS
  ANSIBLE_COLLECTIONS_PATH=${ANSIBLE_COLLECTIONS_PATHS:-}
fi
if [ "$ANSIBLE_COLLECTIONS_PATH" == "" ]; then
  # may be called COLLECTIONS_PATHS
  ANSIBLE_COLLECTIONS_PATH=${COLLECTIONS_PATHS:-}
fi
echo "# Ansible Collections Path: ANSIBLE_COLLECTIONS_PATH (The base collections directory)"
echo "# https://docs.ansible.com/ansible/latest/reference_appendices/config.html#collections-paths"
echo "ANSIBLE_COLLECTIONS_PATH='$ANSIBLE_COLLECTIONS_PATH'"