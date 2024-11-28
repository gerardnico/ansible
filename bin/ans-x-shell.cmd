@echo off
REM Run bash in the Ansible Docker image

SET SCRIPT_PATH=%~dp0

call %SCRIPT_PATH%\ansible-docker-run bash %*