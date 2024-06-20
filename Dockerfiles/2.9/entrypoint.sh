#!/usr/bin/env bash

echo Starting the ssh-agent for convenience
echo And set the environment variable SSH_AUTH_SOCK - ie -s option
eval "$(ssh-agent -s)"

# Loop through the ANSIBLE_SSH_KEY_PASSPHRASE environment variables
SSH_VAR_PREFIX='ANSIBLE_SSH_KEY_PASSPHRASE_'
for var in $(printenv | grep -oP "^$SSH_VAR_PREFIX\K[^=]+")
do
  filename=$(echo "$var" | tr '[:upper:]' '[:lower:]')
  varUppercase=$(echo "$SSH_VAR_PREFIX$var" | tr '[:lower:]' '[:upper:]')
  filePath=~/.ssh/"$filename"
  echo "The SSH env variable $varUppercase was found"
  if [ -f "$filePath" ]; then
    echo "Trying to add the key $filename to the SSH agent"
    ssh-add "$filePath" $"${SSH_VAR_PREFIX}_$var" || exit 1
    echo "The key $filename was added successfully the SSH agent."
  else
    echo "The env variable $varUppercase designs a key file ($filePath) that does not exists"
    exit 1;
  fi
done

echo
# Start the passed command ($*)
/bin/sh -c "$*"
