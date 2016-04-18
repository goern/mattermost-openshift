# This is a Dockerfile to be used with OpenShift3

FROM centos:7

MAINTAINER Christoph Görn <goern@redhat.com>
# based on the work of Takayoshi Kimura <tkimura@redhat.com>

ENV container docker
ENV MATTERMOST_VERSION 2.1.0

# Labels consumed by Red Hat build service
LABEL Component="mattermost" \
      Name="projectatomic/mattermost-210-rhel7" \
      Version="2.1.0" \
      Release="1"

# Labels could be consumed by OpenShift
LABEL io.k8s.description="Mattermost is an open source, self-hosted Slack-alternative" \
      io.k8s.display-name="Mattermost 2.1.0" \
      io.openshift.expose-services="8065:mattermost" \
      io.openshift.tags="mattermost,slack"

# Labels could be consumed by Nulecule Specification
LABEL io.projectatomic.nulecule.environment.required="MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE" \
      io.projectatomic.nulecule.environment.optional="VOLUME_CAPACITY" \
      io.projectatomic.nulecule.volume.data="/var/lib/psql/data,1Gi"

RUN yum update -y --setopt=tsflags=nodocs && \
    yum install -y tar --setopt=tsflags=nodocs && \
    yum clean all

RUN cd /opt && \
    curl -LO https://releases.mattermost.com/2.1.0/mattermost-team-2.1.0-linux-amd64.tar.gz && \
    tar xf mattermost-team-2.1.0-linux-amd64.tar.gz &&\
    rm mattermost-team-2.1.0-linux-amd64.tar.gz

COPY mattermost-launch.sh /opt/mattermost/bin/mattermost-launch.sh
COPY config.json /opt/mattermost/config/config.json
RUN chmod 777 /opt/mattermost/config/config.json && \
    mkdir /opt/mattermost/data && \
    chmod 777 /opt/mattermost/logs/ /opt/mattermost/data

EXPOSE 8065

CMD /opt/mattermost/bin/mattermost-launch.sh
