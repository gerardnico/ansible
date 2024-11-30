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
    apt-get install -y less git &&  \
    echo "==> Install Python Packages (Pip)"  && \
    apt install -y python3-pip

# Installation is done via pipx but pipx is
# pipx is pretty old. We could't install globally (no --global flag)
# that's why we change the env variable
# See all issues here for more info
# * https://github.com/pypa/pipx/discussions/1341
# * https://github.com/pypa/pipx/issues/1337
# * https://github.com/pypa/pipx/issues/754
# Install Ref:
# https://pipx.pypa.io/stable/#on-linux
# https://pipx.pypa.io/stable/installation/#on-linux
ENV PIPX_HOME=/opt/pipx
ENV PIPX_MAN_DIR=/usr/local/share/man
ENV PIPX_BIN_DIR=/usr/local/bin
# Permission denied: '/opt/pipx/.cache/7b9fc6075525630'
# pipx run APP
RUN echo "==> Install Pipx" && \
    mkdir -p $PIPX_HOME && \
    mkdir -p $PIPX_HOME\.cache && \
    apt install -y pipx && \
    echo "==> Pipx Owner is root, we change that" && \
    chmod -R a+rwx $PIPX_HOME


ENV DOCKER_ANSIBLE_VERSION 9.12.0

# https://docs.ansible.com/ansible/latest/reference_appendices/release_and_maintenance.html
# https://pypi.org/project/ansible/#history
# The ansible-core python package contains the core runtime and CLI tools,
# such as ansible and ansible-playbook, while the ansible package contains extra modules, plugins, and roles.
RUN echo "==> Install Ansible" && \
    pipx install --include-deps ansible==$DOCKER_ANSIBLE_VERSION

# https://ansible.readthedocs.io/projects/dev-tools/installation/
# https://pypi.org/project/ansible-dev-tools/
# It does not overrite ansible tools
# It's just a one line command to install all cli
# The version are in
# https://github.com/ansible/ansible-dev-tools/blob/main/.config/constraints.txt
RUN echo "==> Install Ansible Dev tools" && \
    pipx inject --include-deps ansible ansible-dev-tools


# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/#install-kubectl-on-linux
RUN echo "==> Installing Kubectl" && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" && \
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check && \
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Running molecule test with `community.docker' 3.13.1`
# The error was: ModuleNotFoundError: No module named 'requests'
# https://pypi.org/project/requests/
RUN echo "==> Install Python Requests" && \
    pipx inject --include-deps ansible requests==2.32.3

ENV MOLECULE_PLUGIN_VERSION 23.5.3
# https://pypi.org/project/molecule-plugins/
# Molecule Docker driver and others goodies
RUN echo "==> Install Molecule Plugins" && \
    pipx inject --include-deps ansible molecule-plugins==${MOLECULE_PLUGIN_VERSION} && \
    echo "==> Install the Molecule Plugins dependencies" && \
    pipx inject --include-deps ansible molecule-plugins['azure']==${MOLECULE_PLUGIN_VERSION} && \
    pipx inject --include-deps ansible molecule-plugins['containers']==${MOLECULE_PLUGIN_VERSION} && \
    pipx inject --include-deps ansible molecule-plugins['docker']==${MOLECULE_PLUGIN_VERSION} && \
    pipx inject --include-deps ansible molecule-plugins['ec2']==${MOLECULE_PLUGIN_VERSION} && \
    pipx inject --include-deps ansible molecule-plugins['gce']==${MOLECULE_PLUGIN_VERSION} && \
    pipx inject --include-deps ansible molecule-plugins['openstack']==${MOLECULE_PLUGIN_VERSION} && \
    pipx inject --include-deps ansible molecule-plugins['podman']==${MOLECULE_PLUGIN_VERSION} && \
    pipx inject --include-deps ansible molecule-plugins['vagrant']==${MOLECULE_PLUGIN_VERSION}


# https://docs.docker.com/engine/install/ubuntu/
# Molecule needs the docker cli
# containerd.io docker-buildx-plugin docker-compose-plugin
RUN echo "==> Docker install"  && \
    echo "==> Add Docker's official GPG key" && \
    apt-get install ca-certificates curl && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc

RUN echo "==> Add the repository to Apt sources" && \
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    echo "==> Install Docker cli" && \
    apt-get install -y docker-ce-cli

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


