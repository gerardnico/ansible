# Create the env
# Default Ansible version if not set
ANS_X_ANSIBLE_VERSION=${ANS_X_ANSIBLE_VERSION:-2.9}
echo "# The ansible version"
echo "ANS_X_ANSIBLE_VERSION=$ANS_X_ANSIBLE_VERSION"

# ANS_X_DOCKER_REGISTRY
ANS_X_DOCKER_REGISTRY="docker.io"
if [ "$ANS_X_ANSIBLE_VERSION" = "2.9" ]; then
  ANS_X_DOCKER_REGISTRY="ghcr.io"
fi
echo "# The docker registry"
echo "ANS_X_DOCKER_REGISTRY=$ANS_X_DOCKER_REGISTRY"


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