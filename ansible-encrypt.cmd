@echo off
REM Run Ansible vault inside docker

SET SCRIPT_PATH=%~dp0

IF NOT EXIST "passphrase.sh" (
    echo The file passphrase.sh was not found in the current directory
)

call %SCRIPT_PATH%\ansible-docker-run ansible-vault encrypt_string --vault-id passphrase.sh %*