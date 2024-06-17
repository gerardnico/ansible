#!/usr/bin/env bash

echo Starting the ssh-agent for convenience
echo And set the environment variable SSH_AUTH_SOCK - ie -s option
eval "ssh-agent -s"

# Start the passed command ($*)
/bin/sh -c "$*"
