# as described here
# https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu

# Check here the supported distro by name
# https://github.com/ansible-community/ppa/blob/main/latest_builds/matrix.yml
# For ansible 2.9 (ie ansible-9 / version 9): - jammy, mantic, noble
# You can check that they are available here:
# https://ppa.launchpadcontent.net/ansible/ansible-2.9/ubuntu/dists/
# for ie apt-add-repository --yes --update ppa:ansible/ansible-2.9
# Otherwise you need to use the general repository
# https://ppa.launchpadcontent.net/ansible/ansible/ubuntu/dists/
# ie apt-add-repository --yes --update ppa:ansible/ansible
#

# if the dist is not disponible, you get:
# Otherwise you get this error: the repository 'https://ppa.launchpadcontent.net/ansible/ansible-2.8/ubuntu oracular Release' does not have a Release file.

# Ubuntu Noble
# See: https://wiki.ubuntu.com/Releases
# Noble = 24.04
FROM ubuntu:noble-20241015


RUN echo "==> Update"  && \
    apt-get update && \
	echo "==> Install Dev tools..."  && \
	apt-get install -y sudo libssl-dev libffi-dev && \
	echo "==> Install tools..."  && \
	apt-get install -y vim wget jq rsync curl && \
    echo "==> Install Ansible dependency tools (less for ansible-galaxy role info, git for ansible-galaxy role install)"  && \
    apt-get install -y less git

RUN echo "==> Install ansible..."  && \
    # as described here: # https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu \
    # https://github.com/ansible-community/ppa
    apt-get install -y software-properties-common && \
    # big bug \
    # https://ppa.launchpadcontent.net/ansible/ansible-2.9/ubuntu/dists/ does not have jammy mantic of noble \
    # but https://ppa.launchpadcontent.net/ansible/ansible/ubuntu/dists/ have them \
    # so we replace this \
    # apt-add-repository --yes --update ppa:ansible/ansible-$PLAY_ANSIBLE_VERSION && \
    # by:
    apt-add-repository --yes --update ppa:ansible/ansible && \
    # We get 2.9???
    apt-get install -y ansible && \
    echo "==> Update (because https://launchpad.net/~ansible/+archive/ubuntu/ansible-2.9)"  && \
    apt-get update

RUN echo "==> Install Python Packages (Pip, ...)"  && \
    # https://packaging.python.org/en/latest/guides/installing-using-linux-tools/#debian-ubuntu-and-derivatives \
    # python3-dateutil was required when running ansible
    apt install -y python3-venv python3-pip python3-dateutil python3-selinux

# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-on-linux
RUN echo "==> Installing Kubectl" && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" && \
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check && \
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Molecule (Ubuntu)
# python3-pip libssl-dev are already here
# https://ansible.readthedocs.io/projects/molecule/installation/
# old version 1.4.3, we can't use the --global flag
ENV PIPX_HOME=/opt/pipx
ENV PIPX_MAN_DIR=/usr/local/share/man
ENV PIPX_BIN_DIR=/usr/local/bin
# Permission denied: '/opt/pipx/.cache/7b9fc6075525630'
# pipx run APP
RUN echo "==> Install Ansible Dev tools" && \
    mkdir -p $PIPX_HOME && \
    mkdir -p $PIPX_HOME\.cache && \
    apt install -y pipx && \
    pipx install ansible-dev-tools && \
    echo "==> Pipx Owner is root, we change that" && \
    chmod -R a+rwx $PIPX_HOME

ENV PATH=$PIPX_HOME/venvs/ansible-dev-tools/bin:$PATH

RUN echo "==> Adding hosts for convenience..."  && \
    mkdir -p /etc/ansible && \
    echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts


####################################
# Label
# https://docs.docker.com/reference/dockerfile/#label
# This labels are used by Github
####################################
# * connect the repo
LABEL org.opencontainers.image.source="https://github.com/gerardnico/ansible-x"
# * set a description
LABEL org.opencontainers.image.description="Ansible X - Ansible Easy Execution"

# Ansible Env
ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_SSH_PIPELINING True

#ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
#ENV PYTHONPATH /ansible/lib
#ENV ANSIBLE_LIBRARY /ansible/library

# our Own environment variable
# There is only a 2.9 version (ie version 9)
# then the core is then a 2.16
# see the relation here: https://docs.ansible.com/ansible/10/reference_appendices/release_and_maintenance.html#ansible-community-changelogs
# then the python version needs to be 3.10 - 3.12
# See the Matrix Support: https://docs.ansible.com/ansible/latest/reference_appendices/release_and_maintenance.html#ansible-core-support-matrix
ENV DOCKER_ANSIBLE_VERSION 2.9


####################################
# USER
# Group 1000 is used by `ubuntu`
####################################
RUN groupmod --new-name al ubuntu && usermod --login al --move-home --home /home/al ubuntu

####################################
# WorkDir and Work User
# The scripts mount the running user
# therefore the directory should be writable, readable by everybody
# These 2 directories are mounted, so the permissions of this dreictories is not really 0777
# but the permissions of the host
####################################
RUN mkdir -p /ansible && \
    mkdir -p /ansible/project && \
    mkdir -p /ansible/home && \
    chmod -R a+rwx /ansible
WORKDIR /ansible/project
# User should not be set as we support now any other image
# that may not have the al user
# USER al
