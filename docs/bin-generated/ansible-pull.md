% ansible-pull(1) Version Latest | Pulls and execute playbooks from a VCS repo

# NAME

The `ansible-pull` cli pulls and executes playbooks from a VCS repo

Official documentation: [ansible-pull command line cli](https://docs.ansible.com/ansible/latest/cli/ansible-pull.html)

# SYNOPSIS

```bash
usage: ansible-pull [-h] [--version] [-v] [--private-key PRIVATE_KEY_FILE]
                    [-u REMOTE_USER] [-c CONNECTION] [-T TIMEOUT]
                    [--ssh-common-args SSH_COMMON_ARGS]
                    [--sftp-extra-args SFTP_EXTRA_ARGS]
                    [--scp-extra-args SCP_EXTRA_ARGS]
                    [--ssh-extra-args SSH_EXTRA_ARGS]
                    [-k | --connection-password-file CONNECTION_PASSWORD_FILE]
                    [--vault-id VAULT_IDS]
                    [-J | --vault-password-file VAULT_PASSWORD_FILES]
                    [-e EXTRA_VARS] [-t TAGS] [--skip-tags SKIP_TAGS]
                    [-i INVENTORY] [--list-hosts] [-l SUBSET] [-M MODULE_PATH]
                    [-K | --become-password-file BECOME_PASSWORD_FILE]
                    [--purge] [-o] [-s SLEEP] [-f] [-d DEST] [-U URL] [--full]
                    [-C CHECKOUT] [--accept-host-key] [-m MODULE_NAME]
                    [--verify-commit] [--clean] [--track-subs] [--check]
                    [--diff]
                    [playbook.yml ...]

pulls playbooks from a VCS repo and executes them on target host

positional arguments:
  playbook.yml          Playbook(s)

options:
  --accept-host-key     adds the hostkey for the repo url if not already added
  --become-password-file BECOME_PASSWORD_FILE, --become-pass-file BECOME_PASSWORD_FILE
                        Become password file
  --check               don't make any changes; instead, try to predict some
                        of the changes that may occur
  --clean               modified files in the working repository will be
                        discarded
  --connection-password-file CONNECTION_PASSWORD_FILE, --conn-pass-file CONNECTION_PASSWORD_FILE
                        Connection password file
  --diff                when changing (small) files and templates, show the
                        differences in those files; works great with --check
  --full                Do a full clone, instead of a shallow one.
  --list-hosts          outputs a list of matching hosts; does not execute
                        anything else
  --purge               purge checkout after playbook run
  --skip-tags SKIP_TAGS
                        only run plays and tasks whose tags do not match these
                        values. This argument may be specified multiple times.
  --track-subs          submodules will track the latest changes. This is
                        equivalent to specifying the --remote flag to git
                        submodule update
  --vault-id VAULT_IDS  the vault identity to use. This argument may be
                        specified multiple times.
  --vault-password-file VAULT_PASSWORD_FILES, --vault-pass-file VAULT_PASSWORD_FILES
                        vault password file
  --verify-commit       verify GPG signature of checked out commit, if it
                        fails abort running the playbook. This needs the
                        corresponding VCS module to support such an operation
  --version             show program's version number, config file location,
                        configured module search path, module location,
                        executable location and exit
  -C CHECKOUT, --checkout CHECKOUT
                        branch/tag/commit to checkout. Defaults to behavior of
                        repository module.
  -J, --ask-vault-password, --ask-vault-pass
                        ask for vault password
  -K, --ask-become-pass
                        ask for privilege escalation password
  -M MODULE_PATH, --module-path MODULE_PATH
                        prepend colon-separated path(s) to module library
                        (default={{ ANSIBLE_HOME ~
                        "/plugins/modules:/usr/share/ansible/plugins/modules"
                        }}). This argument may be specified multiple times.
  -U URL, --url URL     URL of the playbook repository
  -d DEST, --directory DEST
                        path to the directory to which Ansible will checkout
                        the repository.
  -e EXTRA_VARS, --extra-vars EXTRA_VARS
                        set additional variables as key=value or YAML/JSON, if
                        filename prepend with @. This argument may be
                        specified multiple times.
  -f, --force           run the playbook even if the repository could not be
                        updated
  -h, --help            show this help message and exit
  -i INVENTORY, --inventory INVENTORY, --inventory-file INVENTORY
                        specify inventory host path or comma separated host
                        list. --inventory-file is deprecated. This argument
                        may be specified multiple times.
  -k, --ask-pass        ask for connection password
  -l SUBSET, --limit SUBSET
                        further limit selected hosts to an additional pattern
  -m MODULE_NAME, --module-name MODULE_NAME
                        Repository module name, which ansible will use to
                        check out the repo. Choices are ('git', 'subversion',
                        'hg', 'bzr'). Default is git.
  -o, --only-if-changed
                        only run the playbook if the repository has been
                        updated
  -s SLEEP, --sleep SLEEP
                        sleep for random interval (between 0 and n number of
                        seconds) before starting. This is a useful way to
                        disperse git requests
  -t TAGS, --tags TAGS  only run plays and tasks tagged with these values.
                        This argument may be specified multiple times.
  -v, --verbose         Causes Ansible to print more debug messages. Adding
                        multiple -v will increase the verbosity, the builtin
                        plugins currently evaluate up to -vvvvvv. A reasonable
                        level to start is -vvv, connection debugging might
                        require -vvvv. This argument may be specified multiple
                        times.

Connection Options:
  control as whom and how to connect to hosts

  --private-key PRIVATE_KEY_FILE, --key-file PRIVATE_KEY_FILE
                        use this file to authenticate the connection
  --scp-extra-args SCP_EXTRA_ARGS
                        specify extra arguments to pass to scp only (e.g. -l)
  --sftp-extra-args SFTP_EXTRA_ARGS
                        specify extra arguments to pass to sftp only (e.g. -f,
                        -l)
  --ssh-common-args SSH_COMMON_ARGS
                        specify common arguments to pass to sftp/scp/ssh (e.g.
                        ProxyCommand)
  --ssh-extra-args SSH_EXTRA_ARGS
                        specify extra arguments to pass to ssh only (e.g. -R)
  -T TIMEOUT, --timeout TIMEOUT
                        override the connection timeout in seconds (default
                        depends on connection)
  -c CONNECTION, --connection CONNECTION
                        connection type to use (default=ssh)
  -u REMOTE_USER, --user REMOTE_USER
                        connect as this user (default=None)
```