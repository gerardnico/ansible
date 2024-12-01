# Ansible Project Directory

## About
By default, the project directory available to Ansible is:
* your working directory
* if the env [ANS_X_PROJECT_DIR](#ans_x_project_dir) is not set. 


## ANS_X_PROJECT_DIR

This environment variable defines your project directory (instead of the working directory)

For instance, if you want to start a command inside your project directory 
such as a [molecule](bin-generated/molecule.md) command in the `extensions` directory of a collection
you can set the env variable [ANS_X_PROJECT_DIR](#ans_x_project_dir) to the path of your ansible project.

This directory will then be mounted and used instead of the current working directory.

* In a `.envrc` at the root directory of your project with `direnv`
```bash
export ANS_X_PROJECT_DIR=$PWD
```
