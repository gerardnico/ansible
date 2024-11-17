ANS_X_ENV_FILE=${ANS_X_ENV_FILE:-"$HOME/.bashenv.d/ans-x.sh"}
echo "# The ans-x env file (sourced if exists)"
echo "ANS_X_ENV_FILE=$ANS_X_ENV_FILE"
if [ -f $ANS_X_ENV_FILE ]; then
  source $ANS_X_ENV_FILE
fi

# Create the env
# Default Ansible version if not set
ANS_X_ANSIBLE_VERSION=${ANS_X_ANSIBLE_VERSION:-"2.9"}
echo "# The ansible version"
echo "ANS_X_ANSIBLE_VERSION=$ANS_X_ANSIBLE_VERSION"

# ANS_X_DOCKER_REGISTRY
ANS_X_DOCKER_REGISTRY="docker.io"
if [ "$ANS_X_ANSIBLE_VERSION" = "2.9" ]; then
  ANS_X_DOCKER_REGISTRY="ghcr.io"
fi
echo "# The docker registry"
echo "ANS_X_DOCKER_REGISTRY=$ANS_X_DOCKER_REGISTRY"

echo "# The docker user (the user running the command in the container)"
ANS_X_DOCKER_USER=${ANS_X_DOCKER_USER:-al}
echo "ANS_X_DOCKER_USER=$ANS_X_DOCKER_USER"

# ANS_X_DOCKER_IMAGE_PWD
ANS_X_DOCKER_IMAGE_PWD="/home/al"
if [[ "$ANS_X_ANSIBLE_VERSION" =~ "2.8"|"2.7" ]]; then
  ANS_X_DOCKER_IMAGE_PWD="/ansible/playbook"
fi
echo "# The working directory in the image (Internal, used for migration)"
echo "ANS_X_DOCKER_IMAGE_PWD=$ANS_X_DOCKER_IMAGE_PWD"

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

# Env: HCLOUD_TOKEN, AZURE_TENANT
echo "# A grep pattern expression that selects the env to pass to Ansible docker"
ANS_X_DOCKER_ENVS="^(ANSIBLE|ACTION|AGNOSTIC|ANY|BECOME|CACHE|CALLBACKS|COLLECTIONS|COLOR|CONNECTION|COVERAGE|DEFAULT|DEPRECATION|DEVEL|DIFF|DISPLAY|DOC|DUPLICATE|EDITOR|ENABLE|ERROR|FACTS_MODULES|GALAXY|HOST|INJECT|INTERPRETER|INVALID|INVENTORY|LOG|MAX_FILE_SIZE_FOR_DIFF|MODULE|HCLOUD|AZURE)"
echo "ANS_X_DOCKER_ENVS='$ANS_X_DOCKER_ENVS'"


ANS_X_VAULT_ID_PASS=${ANS_X_VAULT_ID_PASS:-}
echo "# The location of a vault id in the pass secret manager"
echo "ANS_X_VAULT_ID_PASS=$ANS_X_VAULT_ID_PASS"