FROM ubuntu:23.04
# 23:04 is Kunar
# The dist available for ansible 8 are visible here:
# http://ppa.launchpad.net/ansible/ansible-8/ubuntu/dists/

# https://docs.ansible.com/ansible/latest/reference_appendices/release_and_maintenance.html#ansible-community-changelogs
ENV PLAY_PACKAGE_RELEASE_VERSION 8
# The release and the core does not follow the same versioning
ENV PLAY_ANSIBLE_CORE_VERSION 2.15

# Ansible Env
ENV ANSIBLE_GATHERING smart
ENV ANSIBLE_HOST_KEY_CHECKING false
ENV ANSIBLE_RETRY_FILES_ENABLED false
ENV ANSIBLE_SSH_PIPELINING True

#ENV ANSIBLE_ROLES_PATH /ansible/playbooks/roles
#ENV PYTHONPATH /ansible/lib
#ENV ANSIBLE_LIBRARY /ansible/library

# Own environment variable
# Not from Ansible
ENV PLAY_USER ansible
ENV PLAY_BASE /ansible
ENV PLAY_PLAYBOOK $PLAY_BASE/playbooks
ENV PLAY_BIN $PLAY_BASE/bin
ENV PATH $PLAY_BIN:$PATH
ENV ENTRYPOINT_FILE entrypoint.sh
ENV ENTRYPOINT_PATH $PLAY_BIN/$ENTRYPOINT_FILE

RUN echo "==> Update"  && \
    apt-get update && \
	echo "==> Install Dev tools..."  && \
	apt-get install -y sudo libssl-dev libffi-dev python-dev-is-python3 python3-pip && \
	echo "==> Add ansible user ($PLAY_USER)"  && \
    echo "==> and add it in the sudoers group"  && \
    useradd --create-home --user-group -G sudo $PLAY_USER && \
    echo "==> Sudo conf: Nothing"  && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
	echo "==> Install tools..."  && \
	apt-get install -y vim wget jq rsync && \
    echo "==> Install ansible..."  && \
    apt-get install -y software-properties-common && \
    apt-add-repository --yes --update ppa:ansible/ansible-$PLAY_PACKAGE_RELEASE_VERSION && \
    apt-get install -y ansible && \
    echo "==> Update (because https://launchpad.net/~ansible/+archive/ubuntu/ansible-8)"  && \
    apt-get update && \
	echo "==> Adding hosts for convenience..."  && \
    mkdir -p /etc/ansible && \
    echo "[local]" >> /etc/ansible/hosts && \
    echo "localhost" >> /etc/ansible/hosts && \
    echo "===> Python install" && \
    echo "===> use apt-get install python3-xxx to avoid the error, this environment is externally managed" && \
    echo "===> Install Passlib" && \
    # passlib: new Ansible encryption that replaces Python crypt module \
    apt-get install python3-passlib && \
    # Azure no longer supported with this install \
    # https://github.com/ansible/ansible/issues/67255 \
    # https://docs.ansible.com/ansible/latest/scenario_guides/guide_azure.html
	# echo "==> Adding Azure SDK" && \
	echo "==> Adding ansible root"  && \
	mkdir -p $PLAY_BASE && \
	chown $PLAY_USER $PLAY_BASE


RUN	echo "==> Creating the project structure" && \
	mkdir -p $PLAY_BIN && \
	mkdir -p $PLAY_PLAYBOOK

# The Azure file were deleted from the repo and added in the distro in 2.8

# The Entry point script to start the ssh-agent
# Called only with bash at the command line
# COPY will create it under root
COPY $ENTRYPOINT_FILE $ENTRYPOINT_PATH

RUN	echo "==> Giving ownership to $PLAY_USER" && \
    chown -R $PLAY_USER:$PLAY_USER $PLAY_BASE && \
    chmod +x $ENTRYPOINT_PATH


# When using private key, ssh does not want to use an unprotected key
# We need then to start the container has a user, not as root
USER $PLAY_USER

WORKDIR $PLAY_PLAYBOOK

# Azure env
# Need to be set with
# docker run --env <key>=<value>
ENV AZURE_CLIENT_ID=""
ENV AZURE_SECRET=""
ENV AZURE_SUBSCRIPTION_ID=""
ENV AZURE_TENANT=""


# We choose no entrypoint. You need to give the command.
#
# Run Example:
#    docker run --rm -it gerardnico/ansible:2.8 bash
#    docker run --rm -it gerardnico/ansible:2.8 ansible-playbook --version
#    docker run --rm -it gerardnico/ansible:2.8 ansible --version
