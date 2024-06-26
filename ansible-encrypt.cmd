@echo off
REM Ansible vault string encryption
REM the `--vault-id passphrase.sh` argument should be passed or configured in ansible.cfg

SET SCRIPT_PATH=%~dp0


call %SCRIPT_PATH%\ansible-docker-run ansible-vault encrypt_string %*