@echo off
REM Run Ansible pull inside docker

SET SCRIPT_PATH=%~dp0

call %SCRIPT_PATH%\ansible-docker-run ansible-pull %*