# This is a Dockerfile to be used with OpenShift3

FROM centos:7

MAINTAINER Christoph Görn <goern@b4mad.net>
# based on the work of Takayoshi Kimura <tkimura@redhat.com>

ENV container docker
ENV MATTERMOST_VERSION 4.5.0
ENV MATTERMOST_VERSION_SHORT 450

# Labels consumed by Red Hat build service
LABEL Component="mattermost" \
      name="centos/mattermost-${MATTERMOST_VERSION_SHORT}-centos7" \
      vendor=Community \
      Version="${MATTERMOST_VERSION}" \
      Release="1"

# Labels could be consumed by OpenShift
LABEL io.k8s.description="Mattermost is an open source, self-hosted Slack-alternative" \
      io.k8s.display-name="Mattermost {$MATTERMOST_VERSION}" \
      io.openshift.expose-services="8065:mattermost" \
      io.openshift.tags="mattermost,slack"

RUN yum update -y --setopt=tsflags=nodocs && \
    yum install -y --setopt=tsflags=nodocs tar && \
    yum clean all

RUN cd /opt && \
    curl -LO https://releases.mattermost.com/${MATTERMOST_VERSION}/mattermost-team-${MATTERMOST_VERSION}-linux-amd64.tar.gz && \
    tar xf mattermost-team-${MATTERMOST_VERSION}-linux-amd64.tar.gz &&\
    rm mattermost-team-${MATTERMOST_VERSION}-linux-amd64.tar.gz

COPY mattermost-launch.sh /opt/mattermost/bin/mattermost-launch.sh
COPY config.json /opt/mattermost/config/config.json
RUN chmod 777 /opt/mattermost/config/config.json && \
    mkdir /opt/mattermost/data && \
    chmod 777 /opt/mattermost/logs/ /opt/mattermost/data

EXPOSE 8065

WORKDIR /opt/mattermost

CMD [ "/opt/mattermost/bin/mattermost-launch.sh" ]
