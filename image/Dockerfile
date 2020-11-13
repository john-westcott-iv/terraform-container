FROM centos:8

ENV HOME=/var/lib/pgsql

COPY run.sh /run.sh

RUN groupadd -g 26 postgres && \
    useradd -u 26 -g postgres -d /var/lib/pgsql -s /sbin/nologin postgresql && \
    groupadd -g 1001 terraform && \
    useradd -u 1001 -g terraform -d /home/terraform -s /usr/bin/bash terraform && \
    mkdir -p /var/lib/pgsql/data && \
    dnf -y --setopt=tsflags=nodocs install postgresql-server postgresql-contrib openssh-server git azure-cli && \
    dnf -y clean all && \
    chmod 555 /run.sh

EXPOSE 22
ENTRYPOINT /run.sh