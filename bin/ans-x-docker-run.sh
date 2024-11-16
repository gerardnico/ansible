# Run the Ansible docker image
# This script is sourced from the other one

# shellcheck source=../../bash-lib/lib/bashlib-command.sh
source "${BASHLIB_LIBRARY_PATH:-}${BASHLIB_LIBRARY_PATH:+/}bashlib-command.sh"
# shellcheck source=../../bash-lib/lib/bashlib-echo.sh
source "${BASHLIB_LIBRARY_PATH:-}${BASHLIB_LIBRARY_PATH:+/}bashlib-echo.sh"

eval "$(source ans-x-env.sh)"


declare -a ENVS=("run" "--rm")

if [ "$1" == "bash" ]; then
  # The input device is not a TTY. If you are using mintty, try prefixing the command with 'winpty'
  # Docker should not run as an interactive session (only for the docker-bash script)
  ENVS+=("-it")
fi

# ENVS+=("--entrypoint" "/ansible/bin/entrypoint.sh")


# Mounting the current directory or the home if set
ENVS+=("--volume" "$ANS_X_PROJECT_DIR:$ANS_X_DOCKER_IMAGE_PWD")

# User
#ANSIBLE_USER="ansible"
#ENVS+=("--user" "$ANSIBLE_USER")

# Mounting SSH
echo::info "Mounting SSH"
SSH_DOCKER_FORMAT="$HOME/.ssh"
if [[ $(uname -a) =~ "CYGWIN" ]]; then
  SSH_DOCKER_FORMAT="$HOMEPATH/.ssh"
  SSH_DOCKER_FORMAT=$(cygpath -aw "$SSH_DOCKER_FORMAT" | tr 'C:' '/c' | tr '\\' '/')
fi
ENVS+=("--volume" "$SSH_DOCKER_FORMAT:/root/.ssh")

# Setting the ANSIBLE_CONFIG value to avoid
# https://docs.ansible.com/ansible/devel/reference_appendices/config.html#cfg-in-world-writable-dir
# We get a warning so.
ANSIBLE_CONFIG=${ANSIBLE_CONFIG:-ansible.cfg}
ENVS+=("--env" "ANSIBLE_CONFIG=$ANSIBLE_CONFIG")

# Home
ANSIBLE_HOME=${ANSIBLE_HOME:-$ANS_X_DOCKER_IMAGE_PWD}
ENVS+=("--env" "ANSIBLE_HOME=$ANSIBLE_HOME")
# DEFAULT_LOCAL_TMP depends of ansible home
# https://docs.ansible.com/ansible/latest/reference_appendices/config.html#default-local-tmp
ENVS+=("--env" "ANSIBLE_LOCAL_TEMP=/tmp")

# SSH
echo::info "Env (SSH Key Passphrase)"
SSH_PREFIX="ANSIBLE_SSH_KEY_PASSPHRASE_"
if ! SSH_KEYS=$(printenv | grep -P "^$SSH_PREFIX"); then
  SSH_KEYS="";
fi
for var in $SSH_KEYS; do
  varName=$(echo "$var" | grep -oP "^${SSH_PREFIX}[^=]+")
  echo::debug "The SSH variable ($varName) was passed to docker" > /dev/stderr
  ENVS+=("--env" "$var")
done
echo

echo::info "Env (Script)"
echo::info "DOCKER_ANSIBLE_VERSION : $ANS_X_ANSIBLE_VERSION"
echo::info ""
echo::info "Env (Inside Docker)"
echo::info "ANSIBLE_CONFIG : $ANS_X_DOCKER_IMAGE_PWD/$ANSIBLE_CONFIG"
echo::info "ANSIBLE_HOME   : $ANS_X_DOCKER_IMAGE_PWD/$ANSIBLE_HOME"
echo::info ""

# Azure
AZURE_CLIENT_ID=${AZURE_CLIENT_ID:-}
if [ "$AZURE_CLIENT_ID" != "" ]; then
    ENVS+=("--env" "AZURE_CLIENT_ID=$AZURE_CLIENT_ID")
fi
AZURE_SECRET=${AZURE_SECRET:-}
if [ "$AZURE_SECRET" != "" ]; then
    ENVS+=("--env" "AZURE_SECRET=$AZURE_SECRET")
fi
AZURE_SUBSCRIPTION_ID=${AZURE_SUBSCRIPTION_ID:-}
if [ -n "$AZURE_SUBSCRIPTION_ID" ]; then
    ENVS+=("--env" "AZURE_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID")
fi
AZURE_TENANT=${AZURE_TENANT:-}
if [ "$AZURE_TENANT" != "" ]; then
    ENVS+=("--env" "AZURE_TENANT=$AZURE_TENANT")
fi

# Hcloud
# https://docs.ansible.com/ansible/latest/collections/hetzner/hcloud/docsite/guides.html
HCLOUD_TOKEN=${HCLOUD_TOKEN:-}
if [ "$HCLOUD_TOKEN" != "" ]; then
    ENVS+=("--env" "HCLOUD_TOKEN=$HCLOUD_TOKEN")
fi


# Run Docker command

# Secret Options:
# use this file to authenticate the connection
#    --private-key PRIVATE_KEY_FILE, --key-file PRIVATE_KEY_FILE
# ask for vault password
#    -J, --ask-vault-password, --ask-vault-pass
# the vault identity to use. This argument may be specified multiple times.
# --vault-id
#
# --env-file shows up in env in inspect
#
# Works
# echo "secret" > /dev/shm/foo
# docker run --rm -it -v /dev/shm/foo:/tmp/foo  ubuntu bash -c "cat /tmp/foo"
pass ansible/vault-password >| /dev/shm/vault-password

command::echo_eval "docker ${ENVS[*]} \
  -v /dev/shm/foo:/tmp/vault-password \
  $ANS_X_DOCKER_REGISTRY/gerardnico/ansible:$ANS_X_ANSIBLE_VERSION \
  $*"
