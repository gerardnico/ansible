# Run the Ansible docker image
# This script is sourced from the other one

# shellcheck source=../../bash-lib/lib/bashlib-command.sh
source "${BASHLIB_LIBRARY_PATH:-}${BASHLIB_LIBRARY_PATH:+/}bashlib-command.sh"
# shellcheck source=../../bash-lib/lib/bashlib-echo.sh
source "${BASHLIB_LIBRARY_PATH:-}${BASHLIB_LIBRARY_PATH:+/}bashlib-echo.sh"
# shellcheck source=../../bash-lib/lib/bashlib-path.sh
source "${BASHLIB_LIBRARY_PATH:-}${BASHLIB_LIBRARY_PATH:+/}bashlib-path.sh"
# shellcheck source=../../bash-lib/lib/bashlib-bash.sh
source "${BASHLIB_LIBRARY_PATH:-}${BASHLIB_LIBRARY_PATH:+/}bashlib-bash.sh"

echo::debug "Loading env"
ENV=$(source ans-x-env.sh)
if ! ERROR=$(bash::eval_validate "$ENV"); then
  echo::err "Error on env"
  echo::echo "$ERROR"
  exit 1
fi
eval "$ENV"

declare -a ENVS=("run" "--rm")

echo::debug "User Environment Configuration"
# The OS/laptop user should be the owner as we mount volumes
# When using another image than ours the default may be the root user
ENVS+=("--user" "$(id -u):$(id -g)")
if [ -f /etc/passwd ]; then
  # User mount so that we are the mounted user
  # even if user (1000) does not exists in the image
  # Original idea: https://github.com/ansible/ansible-dev-tools/issues/381
  ENVS+=("--volume" "/etc/passwd:/etc/passwd")
fi
# Tools use the HOME user for tmp, ...
# We need to mount it otherwise
# [Errno 13] Permission denied: b'/home/hostUser'
ENVS+=("--volume" "$HOME:$HOME")


######################
# Mount the working directory
######################
echo::debug "Mounting the project/working directory"
ENVS+=("--volume" "$ANS_X_PROJECT_DIR:$ANS_X_PROJECT_DIR")

# Home is mounted
# The project may lies in
# $HOME/.ansible/collections/ansible_collections/
if ! path::relative_to "$HOME" "$PWD"; then
  ENVS+=("--workdir" "$PWD")
else
  # Working directory may be a sub-directory of the project
  # ie molecule starts in extensions
  if ! path::relative_to "$PWD" "$ANS_X_PROJECT_DIR"; then
    ENVS+=("--workdir" "$ANS_X_PROJECT_DIR")
  else
    ENVS+=("--workdir" "$PWD")
  fi
fi

# Docker mount
# If the docker group id exists and is valid the value
# ANS_X_DOCKER_HOST_GROUP_ID is not set
if HOST_DOCKER_GROUP_ID=$(getent group docker | awk -F: '{print $3}'); then
  # Mount Docker
  ENVS+=("--volume" "/var/run/docker.sock:/var/run/docker.sock")
  # Without the docker group, it does not have any permission on /var/run/docker.sock
  # We don't mount the name but the group id because it does a lookup before mounting /etc/group and fails
  ENVS+=("--group-add" "$HOST_DOCKER_GROUP_ID")
  # group injection happens before mounting
  ENVS+=("--volume" "/etc/group:/etc/group")
  # TODO: Check if file ~/.docker/config as the value `desktop`
  # To avoid Error pulling image xxx - docker-credential-desktop.exe not installed or not available in PATH
fi

# Ansible Home
# Note ANSIBLE_HOME is not empty as this points because we called the env file
# All ANSIBLE_XXX env are set later
# Ansible home should exist as we mount it so that it get
if [ ! -d "$ANSIBLE_HOME" ]; then
  mkdir -p "$ANSIBLE_HOME"
fi
if ! ANSIBLE_HOME_RELATIVE_PATH=$(path::relative_to "$ANSIBLE_HOME" "$ANS_X_PROJECT_DIR"); then
  ENVS+=("--volume" "$ANSIBLE_HOME:$ANS_X_DOCKER_IMAGE_ANSIBLE_HOME")
  ANSIBLE_HOME="$ANS_X_DOCKER_IMAGE_ANSIBLE_HOME"
else
  ANSIBLE_HOME="$ANS_X_DOCKER_IMAGE_ANSIBLE_HOME/$ANSIBLE_HOME_RELATIVE_PATH"
fi

# Collections
# https://docs.ansible.com/ansible/latest/reference_appendices/config.html#collections-paths
if [ "$ANSIBLE_COLLECTIONS_PATH" != "" ]; then
  # Set the internal field separator to a colon, but only for the code inside the braces
  while IFS=':' read -r COLLECTION_PATH; do
    ENVS+=("--volume" "$COLLECTION_PATH:$COLLECTION_PATH")
  done <<< "$ANSIBLE_COLLECTIONS_PATH"
fi


# ANSIBLE_LOCAL_TEMP Default to ANSIBLE_HOME
# we don't need to define it anymore
# https://docs.ansible.com/ansible/latest/reference_appendices/config.html#default-local-tmp

######################
# Bash
######################
if [ "$(basename "$0")" == "ans-x-shell" ]; then
  # The input device is not a TTY. If you are using mintty, try prefixing the command with 'winpty'
  # Docker should not run as an interactive session (only for the docker-bash script)
  # Docker it, not bash it
  ENVS+=("-i")
fi

# Terminal (Colors!)
if [ "$ANS_X_DOCKER_TERMINAL" == "1" ]; then
  ENVS+=("-t")
fi

# Deprecated: 2024-11-28
# We mount the home and therefore also ~/.ssh
######################
# Mount SSH Directory
######################
#echo::debug "Mounting SSH if needed"
## https://docs.ansible.com/ansible/devel/reference_appendices/config.html#default-private-key-file
#SSH_VAR_PREFIX='ANS_X_SSH_KEY_PASSPHRASE_'
#if printenv | grep -oP "$SSH_VAR_PREFIX|DEFAULT_PRIVATE_KEY_FILE|ANSIBLE_PRIVATE_KEY_FILE"; then
#  echo::debug "We mount SSH"
#  SSH_DOCKER_FORMAT="$HOME/.ssh"
#  if [[ $(uname -a) =~ "CYGWIN" ]]; then
#    SSH_DOCKER_FORMAT="$HOMEPATH/.ssh"
#    SSH_DOCKER_FORMAT=$(cygpath -aw "$SSH_DOCKER_FORMAT" | tr 'C:' '/c' | tr '\\' '/')
#  fi
#  ENVS+=("--volume" "$SSH_DOCKER_FORMAT:/home/$ANS_X_DOCKER_USER/.ssh")
#fi

######################
# Hostname
######################
echo::debug "Hostname"
# (Point are not welcome, so we transform it with a underscore
ENVS+=("-h" "ansible-${ANS_X_DOCKER_TAG//./_}")

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
    pass "$ANS_X_PASSWORD_PASS" >| $PASS_LOCAL_PATH

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
    pass "$ANS_X_BECOME_PASSWORD_PASS" >| $PASS_LOCAL_PATH

    ENVS+=("--env" "ANSIBLE_BECOME_PASSWORD_FILE=$PASS_DOCKER_PATH")
    ENVS+=("-v" "$PASS_LOCAL_PATH:$PASS_DOCKER_PATH")

  fi
fi

# ANSIBLE_VAULT_PASSWORD_FILE
# https://docs.ansible.com/ansible/devel/reference_appendices/config.html#envvar-ANSIBLE_VAULT_PASSWORD_FILE
if [ "${ANSIBLE_VAULT_PASSWORD_FILE:-}" != '' ]; then
  ENVS+=("-v" "$ANSIBLE_VAULT_PASSWORD_FILE:$ANSIBLE_VAULT_PASSWORD_FILE")
else
  if [ "${ANS_X_VAULT_ID_PASS:-}" != "" ]; then
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
  if [ "${ANS_X_SSH_KEY_PASS:-}" != "" ]; then
    PRIVATE_KEY_PASS_FILE="${PASSWORD_STORE_DIR:-"$HOME~/.password-store"}/$ANS_X_SSH_KEY_PASS.gpg"
    if [ ! -f "$PRIVATE_KEY_PASS_FILE" ]; then
      echo::err "The pass ${ANS_X_SSH_KEY_PASS} of the env ANS_X_SSH_KEY_PASS does not exist ($PRIVATE_KEY_PASS_FILE)"
      exit 1
    fi
    PASS_DOCKER_PATH=/tmp/ssh-key
    PASS_LOCAL_PATH=/dev/shm/ssh-key
    pass "$ANS_X_SSH_KEY_PASS" >| $PASS_LOCAL_PATH
    # env for --private-key
    ENVS+=("--env" "ANSIBLE_PRIVATE_KEY_FILE=$PASS_DOCKER_PATH")
    ENVS+=("-v" "$PASS_LOCAL_PATH:$PASS_DOCKER_PATH")
  else
      # Loop through the ANS_X_SSH_KEY_PASSPHRASE environment variables
      # and add the key to the agent
      #
      # Example:
      # With the env `ANS_X_SSH_KEY_PASSPHRASE_MY_KEY` the script below will:
      # * try to find a file at `~/.ssh/my_key`
      # * add it with the value of `ANS_X_SSH_KEY_PASSPHRASE_MY_KEY` as passphrase
      #
      SSH_VAR_PREFIX='ANS_X_SSH_KEY_PASSPHRASE_'
      if SSH_VARS=$(printenv | grep -oP "^$SSH_VAR_PREFIX\K[^=]+"); then
        for var in $SSH_VARS
        do
          filename=$(echo "$var" | tr '[:upper:]' '[:lower:]')
          fullVariableName="$SSH_VAR_PREFIX$var"
          filePath=~/.ssh/"$filename"
          echo::debug "The SSH env variable $fullVariableName was found"
          if [ -f "$filePath" ]; then
            PASS_DOCKER_PATH=/tmp/ssh-key
            PASS_LOCAL_PATH=/dev/shm/ssh-key
            PASSPHRASE=$(eval "echo \$$SSH_VAR_PREFIX$var")
            ssh-keygen -p -P "$PASSPHRASE" -N "" -f $PASS_LOCAL_PATH
            # env for --private-key
            ENVS+=("--env" "ANSIBLE_PRIVATE_KEY_FILE=$PASS_DOCKER_PATH")
            ENVS+=("-v" "$PASS_LOCAL_PATH:$PASS_DOCKER_PATH")
          else
            echo::debug "The env variable $fullVariableName designs a key file ($filePath) that does not exist" >&2
            exit 1;
          fi
        done
      fi
  fi

fi


command::echo_eval "docker ${ENVS[*]} \
  $ANS_X_DOCKER_REGISTRY/$ANS_X_DOCKER_NAMESPACE/$ANS_X_DOCKER_NAME:$ANS_X_DOCKER_TAG \
  $*"
