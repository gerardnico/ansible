@echo off
REM Run Ansible vault inside docker

SET SCRIPT_PATH=%~dp0

call %SCRIPT_PATH%\ansible-docker-run ansible-galaxy %*