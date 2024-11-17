# Run the Ansible docker image
# This script is sourced from the other one

# shellcheck source=../../bash-lib/lib/bashlib-command.sh
source "${BASHLIB_LIBRARY_PATH:-}${BASHLIB_LIBRARY_PATH:+/}bashlib-command.sh"
# shellcheck source=../../bash-lib/lib/bashlib-echo.sh
source "${BASHLIB_LIBRARY_PATH:-}${BASHLIB_LIBRARY_PATH:+/}bashlib-echo.sh"

ENV=$(source ans-x-env.sh)
if ! eval "$ENV"; then
  echo::err "Error on env"
  echo::echo "$ENV"
  exit 1
fi

declare -a ENVS=("run" "--rm")


if [ "$1" == "bash" ]; then
  # The input device is not a TTY. If you are using mintty, try prefixing the command with 'winpty'
  # Docker should not run as an interactive session (only for the docker-bash script)
  ENVS+=("-it")
fi


# Mounting the current directory or the home if set
ENVS+=("--volume" "$ANS_X_PROJECT_DIR:$ANS_X_DOCKER_IMAGE_PWD")


# Mounting SSH
echo::info "Mounting SSH"
SSH_DOCKER_FORMAT="$HOME/.ssh"
if [[ $(uname -a) =~ "CYGWIN" ]]; then
  SSH_DOCKER_FORMAT="$HOMEPATH/.ssh"
  SSH_DOCKER_FORMAT=$(cygpath -aw "$SSH_DOCKER_FORMAT" | tr 'C:' '/c' | tr '\\' '/')
fi
ENVS+=("--volume" "$SSH_DOCKER_FORMAT:/home/$ANS_X_DOCKER_USER/.ssh")


# SSH
echo::info "Env (SSH Key Passphrase)"
SSH_PREFIX="ANSIBLE_SSH_KEY_PASSPHRASE_"
if ! SSH_KEYS=$(printenv | grep -P "^$SSH_PREFIX"); then
  SSH_KEYS="";
fi
for var in $SSH_KEYS; do
  varName=$(echo "$var" | grep -oP "^${SSH_PREFIX}[^=]+")
  ENVS+=("--env" "$var")
done


# Hostname
# (Point are not welcome, so we transform it with a underscore
ENVS+=("-h" "ansible-${ANS_X_ANSIBLE_VERSION//./_}")

# We copy the ANSIBLE env
# https://docs.ansible.com/ansible/latest/reference_appendices/config.html
if ! ANSIBLE_ENVS=$(printenv | grep -P "$ANS_X_DOCKER_ENVS"); then
  ANSIBLE_ENVS="";
fi
for ANSIBLE_ENV in $ANSIBLE_ENVS; do
  ENVS+=("--env" "$ANSIBLE_ENV")
done
# Setting the ANSIBLE_CONFIG value to avoid
# https://docs.ansible.com/ansible/devel/reference_appendices/config.html#cfg-in-world-writable-dir
# We get a warning so.
# ANSIBLE_CONFIG=${ANSIBLE_CONFIG:-ansible.cfg}
# ENVS+=("--env" "ANSIBLE_CONFIG=$ANSIBLE_CONFIG")

# DEFAULT_LOCAL_TMP depends of ansible home
# https://docs.ansible.com/ansible/latest/reference_appendices/config.html#default-local-tmp
if [ "${ANSIBLE_LOCAL_TEMP:-}" = "" ]; then
  ENVS+=("--env" "ANSIBLE_LOCAL_TEMP=/tmp")
fi



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
PASS_FILE="${PASSWORD_STORE_DIR:-"$HOME~/.password-store"}/$ANS_X_VAULT_ID_PASS.gpg"
if [ -f "$PASS_FILE" ]; then
  PASS_DOCKER_PATH=/tmp/vault-password
  PASS_LOCAL_PATH=/dev/shm/vault-password
  pass $ANS_X_VAULT_ID_PASS >| $PASS_LOCAL_PATH
  # env for --vault-id
  ENVS+=("--env" "ANSIBLE_VAULT_PASSWORD_FILE=$PASS_DOCKER_PATH")
  ENVS+=("-v" "$PASS_LOCAL_PATH:$PASS_DOCKER_PATH")
fi


command::echo_eval "docker ${ENVS[*]} \
  $ANS_X_DOCKER_REGISTRY/gerardnico/ansible:$ANS_X_ANSIBLE_VERSION \
  $*"
