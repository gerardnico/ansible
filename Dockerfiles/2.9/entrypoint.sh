#!/usr/bin/env bash

## SSH
## We start the SSH agent and add keys if we find env variables that starts with a special prefix

## Starting the SSH Agent
echo Starting the ssh-agent
# -s option set the environment variable SSH_AUTH_SOCK used by third tool such as ssh-add
eval "$(ssh-agent -s)"

# Loop through the ANSIBLE_SSH_KEY_PASSPHRASE environment variables
# and add the key to the agent
# Example:
# With the env `ANSIBLE_SSH_KEY_PASSPHRASE_MY_KEY` the script below will:
# * try to find a file at `~/.ssh/my_key`
# * add it with the value of `ANSIBLE_SSH_KEY_PASSPHRASE_MY_KEY` as passphrase
#
SSH_VAR_PREFIX='ANSIBLE_SSH_KEY_PASSPHRASE_'
for var in $(printenv | grep -oP "^$SSH_VAR_PREFIX\K[^=]+")
do
  filename=$(echo "$var" | tr '[:upper:]' '[:lower:]')
  fullVariableName="$SSH_VAR_PREFIX$var"
  filePath=~/.ssh/"$filename"
  echo "The SSH env variable $fullVariableName was found"
  if [ -f "$filePath" ]; then
    echo "Trying to add the key $filename to the SSH agent"
    # The instruction is in the man page. SSH_ASKPASS needs a path to an executable
    # that emits the secret to stdout.
    # See doc: https://man.archlinux.org/man/ssh.1.en#SSH_ASKPASS
    SSH_ASKPASS="$HOME/.ssh/askpass.sh"
    echo "  - Creating the executable $SSH_ASKPASS"
    PASSPHRASE=$(eval "echo \$$SSH_VAR_PREFIX$var")
    printf "#!/bin/sh\necho %s\n" "$PASSPHRASE" > "$SSH_ASKPASS"
    chmod +x "$SSH_ASKPASS"
    TIMEOUT=5
    echo "  - Executing ssh-add (if the passphrase is incorrect, the execution will freeze for ${TIMEOUT} sec)"
    # freeze due to SSH_ASKPASS_REQUIRE=force otherwise it will ask it at the terminal
    BAD_PASSPHRASE_RESULT="Bad passphrase"
    result=$(timeout $TIMEOUT bash -c "DISPLAY=:0 SSH_ASKPASS_REQUIRE=force SSH_ASKPASS=$SSH_ASKPASS ssh-add $filePath" 2>&1 || echo "$BAD_PASSPHRASE_RESULT")
    echo "  - $result" # should be `Identity added:xxx`
    [ "$result" == "$BAD_PASSPHRASE_RESULT" ] && exit 1;
  else
    echo "The env variable $fullVariableName designs a key file ($filePath) that does not exist" >&2
    exit 1;
  fi
done

# Deprecated 2024-06-29: We use eval for now.
# Quote the args
# We put single quote around arguments so that a `$` will not be seen as a variable
#quoted_args=""
#for arg in "$@"; do
#  quoted_args+="'$arg' "
#done
#quoted_args=${quoted_args% } # Remove the trailing space
#
#echo
#/bin/sh -c "$quoted_args"

# Eval
# Eval permits to pass the quote and to avoid that a `$` character will be seen as a variable
# Using `/bin/sh -c "$@"` will see the `$` character as a variable
eval "$@"


