@echo off
REM Run the Ansible docker image
REM This script is called from the other one

SET SCRIPT_PATH=%~dp0

REM set the azure configuration
REM you need to copy the file azure-conf-dist.cmd to azure-conf.cmd and set your value
SET AZURE_CONF_FILE=azure-conf.cmd

if exist %AZURE_CONF_FILE% (
   call %AZURE_CONF_FILE%
)

if not defined ANSIBLE_VERSION (
    SET ANSIBLE_VERSION=2.8
)
echo Ansible Version: %ANSIBLE_VERSION%

if "%1" == "bash" (
  SET ENTRY_POINT=--entrypoint /ansible/bin/entrypoint.sh
  REM the input device is not a TTY. If you are using mintty, try prefixing the command with 'winpty'
  REM docker should not run as an interactive session (only for the docker-bash script)
  SET INTERACTIVE=-it
) else (
  SET ENTRY_POINT=
  SET INTERACTIVE=
)

docker run ^
    --name ansible ^
	--rm ^
	%INTERACTIVE% ^
	-v %cd%:/ansible/playbooks ^
	--env AZURE_CLIENT_ID=%AZURE_CLIENT_ID% ^
	--env AZURE_SECRET=%AZURE_SECRET% ^
	--env AZURE_SUBSCRIPTION_ID=%AZURE_SUBSCRIPTION_ID% ^
	--env AZURE_TENANT=%AZURE_TENANT% ^
	--user ansible ^
	%ENTRY_POINT% ^
	gerardnico/ansible:%ANSIBLE_VERSION% ^
	%*
