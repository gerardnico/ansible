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

if "%ANSIBLE_VERSION%"=="" (
    SET ANSIBLE_VERSION=2.9
)

if "%1" == "bash" (
  SET ENTRY_POINT=--entrypoint /ansible/bin/entrypoint.sh
  REM the input device is not a TTY. If you are using mintty, try prefixing the command with 'winpty'
  REM docker should not run as an interactive session (only for the docker-bash script)
  SET INTERACTIVE=-it
) else (
  SET ENTRY_POINT=
  SET INTERACTIVE=
)

REM Fixed working directory in the Dockerfile
SET DOCKER_WORKING_DIR=/ansible/playbooks


if not defined ANSIBLE_CONFIG (SET ANSIBLE_CONFIG=ansible.cfg)
if not defined ANSIBLE_HOME (SET ANSIBLE_HOME=%DOCKER_WORKING_DIR%)

echo Ansible Env Inside Docker:
echo ANSIBLE_VERSION : %ANSIBLE_VERSION%
echo ANSIBLE_CONFIG : %DOCKER_WORKING_DIR%/%ANSIBLE_CONFIG%
echo ANSIBLE_HOME   : %DOCKER_WORKING_DIR%/%ANSIBLE_HOME%
echo

REM no name is given to the container because otherwise it's not possible to start two ansible session
docker run ^
	--rm ^
	%INTERACTIVE% ^
	-v %cd%:%DOCKER_WORKING_DIR% ^
	--env AZURE_CLIENT_ID=%AZURE_CLIENT_ID% ^
	--env AZURE_SECRET=%AZURE_SECRET% ^
	--env AZURE_SUBSCRIPTION_ID=%AZURE_SUBSCRIPTION_ID% ^
	--env AZURE_TENANT=%AZURE_TENANT% ^
	--env ANSIBLE_CONFIG=%DOCKER_WORKING_DIR%/%ANSIBLE_CONFIG% ^
	--env ANSIBLE_HOME=%DOCKER_WORKING_DIR%/%ANSIBLE_HOME% ^
	--user ansible ^
	%ENTRY_POINT% ^
	gerardnico/ansible:%ANSIBLE_VERSION% ^
	%*
