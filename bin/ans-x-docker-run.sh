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

# DEFAULT_LOCAL_TMP depends of ansible home
# https://docs.ansible.com/ansible/latest/reference_appendices/config.html#default-local-tmp
if [ "${ANSIBLE_LOCAL_TEMP:-}" = "" ]; then
  ENVS+=("--env" "ANSIBLE_LOCAL_TEMP=/tmp")
fi

######################
# Bash
######################
if [ "$(basename "$0")" == "ans-x-bash" ]; then
  # The input device is not a TTY. If you are using mintty, try prefixing the command with 'winpty'
  # Docker should not run as an interactive session (only for the docker-bash script)
  ENVS+=("-it")
fi

######################
# Mount the directory
######################
echo::debug "Mounting the current directory or the home if set"
ENVS+=("--volume" "$ANS_X_PROJECT_DIR:$ANS_X_DOCKER_IMAGE_PWD")


######################
# Mount SSH Directory
######################
echo::debug "Mounting SSH?"
# https://docs.ansible.com/ansible/devel/reference_appendices/config.html#default-private-key-file
SSH_VAR_PREFIX='ANS_X_SSH_KEY_PASSPHRASE_'
if printenv | grep -oP "$SSH_VAR_PREFIX|DEFAULT_PRIVATE_KEY_FILE|ANSIBLE_PRIVATE_KEY_FILE"; then
  echo::debug "We mount SSH"
  SSH_DOCKER_FORMAT="$HOME/.ssh"
  if [[ $(uname -a) =~ "CYGWIN" ]]; then
    SSH_DOCKER_FORMAT="$HOMEPATH/.ssh"
    SSH_DOCKER_FORMAT=$(cygpath -aw "$SSH_DOCKER_FORMAT" | tr 'C:' '/c' | tr '\\' '/')
  fi
  ENVS+=("--volume" "$SSH_DOCKER_FORMAT:/home/$ANS_X_DOCKER_USER/.ssh")
fi

######################
# Hostname
######################
echo::debug "Hostname"
# (Point are not welcome, so we transform it with a underscore
ENVS+=("-h" "ansible-${ANS_X_ANSIBLE_VERSION//./_}")

######################
# Env
######################
# We copy the ANSIBLE env
# https://docs.ansible.com/ansible/latest/reference_appendices/config.html
if ! ANSIBLE_ENVS=$(printenv | grep -P "$ANS_X_DOCKER_ENVS"); then
  ANSIBLE_ENVS="";
fi
for ANSIBLE_ENV in $ANSIBLE_ENVS; do
  ENVS+=("--env" "$ANSIBLE_ENV")
done



################
# SSH Connection
################
echo::debug "Env (SSH Key Passphrase)"
SSH_PREFIX="ANSIBLE_SSH_KEY_PASSPHRASE_"
if ! SSH_KEYS=$(printenv | grep -P "^$SSH_PREFIX"); then
  SSH_KEYS="";
fi
for var in $SSH_KEYS; do
  varName=$(echo "$var" | grep -oP "^${SSH_PREFIX}[^=]+")
  ENVS+=("--env" "$var")
done

# ANSIBLE_CONNECTION_PASSWORD_FILE
# https://docs.ansible.com/ansible/devel/reference_appendices/config.html#envvar-ANSIBLE_CONNECTION_PASSWORD_FILE
# Password file
if [ "${ANSIBLE_CONNECTION_PASSWORD_FILE:-}" != "" ]; then
  ENVS+=("-v" "$ANSIBLE_CONNECTION_PASSWORD_FILE:$ANSIBLE_CONNECTION_PASSWORD_FILE")
else
  if [ "${ANS_X_PASSWORD_PASS:-}" != "" ]; then
    PASSWORD_PASS_FILE="${PASSWORD_STORE_DIR:-"$HOME~/.password-store"}/$ANS_X_PASSWORD_PASS.gpg"
    if [ ! -f "$PASSWORD_PASS_FILE" ]; then
      echo::err "The pass ${ANS_X_PASSWORD_PASS} of the env ANS_X_PASSWORD_PASS does not exist"
      exit 1
    fi

    PASS_DOCKER_PATH=/tmp/user-password
    PASS_LOCAL_PATH=/dev/shm/user-password
    pass $ANS_X_PASSWORD_PASS >| $PASS_LOCAL_PATH

    ENVS+=("--env" "ANSIBLE_CONNECTION_PASSWORD_FILE=$PASS_DOCKER_PATH")
    ENVS+=("-v" "$PASS_LOCAL_PATH:$PASS_DOCKER_PATH")
  fi
fi

# ANSIBLE_BECOME_PASSWORD_FILE
# https://docs.ansible.com/ansible/devel/reference_appendices/config.html#envvar-ANSIBLE_BECOME_PASSWORD_FILE
# Password become file
if [ "${ANSIBLE_BECOME_PASSWORD_FILE:-}" != "" ]; then
  ENVS+=("-v" "$ANSIBLE_BECOME_PASSWORD_FILE:$ANSIBLE_BECOME_PASSWORD_FILE")
else
  if [ "${ANS_X_BECOME_PASSWORD_PASS:-}" != "" ]; then
    BECOME_PASSWORD_PASS_FILE="${PASSWORD_STORE_DIR:-"$HOME~/.password-store"}/$ANS_X_BECOME_PASSWORD_PASS.gpg"
    if [ ! -f "$BECOME_PASSWORD_PASS_FILE" ]; then
      echo::err "The pass ${ANS_X_BECOME_PASSWORD_PASS} of the env ANS_X_BECOME_PASSWORD_PASS does not exist at $BECOME_PASSWORD_PASS_FILE"
      exit 1
    fi

    PASS_DOCKER_PATH=/tmp/become-user-password
    PASS_LOCAL_PATH=/dev/shm/become-user-password
    pass $ANS_X_BECOME_PASSWORD_PASS >| $PASS_LOCAL_PATH

    ENVS+=("--env" "ANSIBLE_BECOME_PASSWORD_FILE=$PASS_DOCKER_PATH")
    ENVS+=("-v" "$PASS_LOCAL_PATH:$PASS_DOCKER_PATH")

  fi
fi

# ANSIBLE_VAULT_PASSWORD_FILE
# https://docs.ansible.com/ansible/devel/reference_appendices/config.html#envvar-ANSIBLE_VAULT_PASSWORD_FILE
if [ "${ANSIBLE_VAULT_PASSWORD_FILE:-}" != '' ]; then
  ENVS+=("-v" "$ANSIBLE_VAULT_PASSWORD_FILE:$ANSIBLE_VAULT_PASSWORD_FILE")
else
  if [ ${ANS_X_VAULT_ID_PASS:-} != "" ]; then
    VAULT_ID_PASS_FILE="${PASSWORD_STORE_DIR:-"$HOME~/.password-store"}/$ANS_X_VAULT_ID_PASS.gpg"
    if [ ! -f "$VAULT_ID_PASS_FILE" ]; then
      echo::err "The pass ${ANS_X_VAULT_ID_PASS} of the env ANS_X_VAULT_ID_PASS does not exist"
      exit 1
    fi
    PASS_DOCKER_PATH=/tmp/vault-password
    PASS_LOCAL_PATH=/dev/shm/vault-password
    pass $ANS_X_VAULT_ID_PASS >| $PASS_LOCAL_PATH
    # env for --vault-id
    ENVS+=("--env" "ANSIBLE_VAULT_PASSWORD_FILE=$PASS_DOCKER_PATH")
    ENVS+=("-v" "$PASS_LOCAL_PATH:$PASS_DOCKER_PATH")
  fi
fi


# ANSIBLE_PRIVATE_KEY_FILE
# https://docs.ansible.com/ansible/devel/reference_appendices/config.html#envvar-ANSIBLE_PRIVATE_KEY_FILE
if [ "${ANSIBLE_PRIVATE_KEY_FILE:-}" != '' ]; then
  ENVS+=("-v" "$ANSIBLE_PRIVATE_KEY_FILE:$ANSIBLE_PRIVATE_KEY_FILE")
else
  if [ ${ANS_X_SSH_KEY_PASS:-} != "" ]; then
    PRIVATE_KEY_PASS_FILE="${PASSWORD_STORE_DIR:-"$HOME~/.password-store"}/$ANS_X_SSH_KEY_PASS.gpg"
    if [ ! -f "$PRIVATE_KEY_PASS_FILE" ]; then
      echo::err "The pass ${ANS_X_SSH_KEY_PASS} of the env ANS_X_SSH_KEY_PASS does not exist ($PRIVATE_KEY_PASS_FILE)"
      exit 1
    fi
    PASS_DOCKER_PATH=/tmp/ssh-key
    PASS_LOCAL_PATH=/dev/shm/ssh-key
    pass $ANS_X_SSH_KEY_PASS >| $PASS_LOCAL_PATH
    # env for --private-key
    ENVS+=("--env" "ANSIBLE_PRIVATE_KEY_FILE=$PASS_DOCKER_PATH")
    ENVS+=("-v" "$PASS_LOCAL_PATH:$PASS_DOCKER_PATH")
  fi
fi


command::echo_eval "docker ${ENVS[*]} \
  $ANS_X_DOCKER_REGISTRY/gerardnico/ansible:$ANS_X_ANSIBLE_VERSION \
  $*"
