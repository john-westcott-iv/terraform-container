FROM centos:8

# Create postgres user
RUN groupadd -g 26 postgres
RUN useradd -u 26 -g postgres -d /var/lib/pgsql -s /sbin/nologin postgres
RUN mkdir -p /var/lib/pgsql/data
COPY sudoers_postgres /etc/sudoers.d/postgres

# Create terraform user
RUN groupadd -g 1001 terraform
RUN useradd -u 1001 -g terraform -d /home/terraform -s /usr/bin/bash terraform
RUN mkdir /home/terraform/.ssh /home/terraform/bin /home/terraform/terraform_scratch
RUN curl -o /tmp/terraform.zip https://releases.hashicorp.com/terraform/0.13.4/terraform_0.13.4_linux_amd64.zip
# We need unzip to download terraform
RUN dnf install -y unzip
RUN cd /home/terraform/bin && unzip /tmp/terraform.zip
RUN dnf remove -y unzip
RUN chown -R terraform:terraform /home/terraform/.ssh /home/terraform/bin /home/terraform/terraform_scratch
RUN chmod 700 /home/terraform/.ssh /home/terraform/bin /home/terraform/terraform_scratch

# Install terraform SSH key
COPY authorized_keys /home/terraform/.ssh/authorized_keys
RUN chmod 600 /home/terraform/.ssh/authorized_keys && chown terraform:terraform /home/terraform/.ssh/authorized_keys

# Setup the MS repo for azure-cli
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc
COPY azure-cli.repo /etc/yum.repos.d/azure-cli.repo

# Install software
RUN dnf -y --setopt=tsflags=nodocs install postgresql-server postgresql-contrib openssh-server git azure-cli sudo
RUN dnf -y clean all

# Generate the required SSHD keys
RUN ssh-keygen -A

# Prep exec time script
COPY run.sh /run.sh
RUN chmod 555 /run.sh

# Expose port 22 and setup the two persistent volumes
EXPOSE 22
VOLUME /var/lib/pgsql
VOLUME /home/terraform/terraform_scratch

USER 26
ENTRYPOINT /run.sh
