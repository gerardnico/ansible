#!/usr/bin/env bash

echo Starting the ssh-agent for convenience
eval "$(ssh-agent -s)"

# Start the passed command ($*)
/bin/sh -c "$*"
