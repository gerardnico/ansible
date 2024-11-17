#!/usr/bin/env bash

if [ $# -eq 0 ]; then
  echo "A command is mandatory" > /dev/stderr
  exit 1
fi

## SSH
# Loop through the ANSIBLE_SSH_KEY_PASSPHRASE environment variables
# and add the key to the agent
#
# Example:
# With the env `ANSIBLE_SSH_KEY_PASSPHRASE_MY_KEY` the script below will:
# * try to find a file at `~/.ssh/my_key`
# * add it with the value of `ANSIBLE_SSH_KEY_PASSPHRASE_MY_KEY` as passphrase
#
SSH_VAR_PREFIX='ANS_X_SSH_KEY_PASSPHRASE_'
if [ SSH_VARS=$(printenv | grep -oP "^$SSH_VAR_PREFIX\K[^=]+") ]; then

  ## Starting the SSH Agent
  echo Starting the ssh-agent > /dev/stderr
  # -s option set the environment variable SSH_AUTH_SOCK used by third tool such as ssh-add
  eval "$(ssh-agent -s)" 1>/dev/stderr

  for var in $SSH_VARS
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
fi

# For debug
echo "Command executed: $*" > /dev/stderr

"$@"


