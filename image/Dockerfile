FROM centos:8

# Install the MS repo file
COPY azure-cli.repo /etc/yum.repos.d/azure-cli.repo

RUN \
    # Create postgres user
    groupadd -g 26 postgres && \
    useradd -u 26 -g postgres -d /var/lib/pgsql -s /sbin/nologin postgres && \
    mkdir -p /var/lib/pgsql/data && \
    # Create terraform user
    groupadd -g 1001 terraform && \
    useradd -u 1001 -g terraform -d /home/terraform -s /usr/bin/bash terraform && \
    mkdir /home/terraform/.ssh /home/terraform/bin /home/terraform/terraform_scratch && \
    curl -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.13.4/terraform_0.13.4_linux_amd64.zip && \
    # We need unzip to download terraform
    dnf install -y unzip && \
    cd /home/terraform/bin && unzip /tmp/terraform.zip && \
    dnf remove -y unzip && \
    chown -R terraform:terraform /home/terraform/.ssh /home/terraform/bin /home/terraform/terraform_scratch && \
    chmod 700 /home/terraform/.ssh /home/terraform/bin /home/terraform/terraform_scratch && \
    # Setup the MS repo for azure-cli
    rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    # Install software
    dnf -y --setopt=tsflags=nodocs install postgresql-server postgresql-contrib openssh-server git azure-cli sudo && \
    dnf -y clean all && \
    # Generate the required SSHD keys
    ssh-keygen -A

# Install terraform SSH key (this has to be done after the terraform user is created)
COPY --chown=terraform:terraform authorized_keys /home/terraform/.ssh/authorized_keys

# Prep terraform_init.sh and exec time scripts
COPY terraform_init.sh /terraform_init.sh
COPY run.sh /run.sh
RUN chmod 555 /run.sh /terraform_init.sh

# Install sudoers
COPY sudoers_postgres /etc/sudoers.d/postgres

# Expose port 22 and setup the two persistent volumes
EXPOSE 22
VOLUME /var/lib/pgsql
VOLUME /home/terraform/terraform_scratch

USER 26
ENTRYPOINT /run.sh
