# This is a Dockerfile to be used with OpenShift3

FROM centos:7

MAINTAINER Christoph Görn <goern@redhat.com>
# based on the work of Takayoshi Kimura <tkimura@redhat.com>

ENV container docker
ENV MATTERMOST_VERSION 3.0.1
ENV MATTERBRIDGE_PLUS_VERSION 0.3

# Labels consumed by Red Hat build service
LABEL Component="matterbride-plus" \
      Name="centos/matterbride-plus-02-rhel7" \
      Version="0.3" \
      Release="1"

# Labels could be consumed by OpenShift
LABEL io.k8s.description="A bridge between Mattermost and IRC (using mattermost API)" \
      io.k8s.display-name="matterbride-plus 0.3" \
      io.openshift.tags="mattermost,matterbridge,matterbride-plus,slack"

# Labels could be consumed by Nulecule Specification
LABEL io.projectatomic.nulecule.environment.required="MATTERMOST_HOST, MATTERMOST_PORT, MATTERMOST_BOT_USERNAME, MATTERMOST_BOT_PASSWORD"

RUN yum update -y --setopt=tsflags=nodocs && \
    yum clean all

RUN mkdir -p /opt/matterbridge-plus && \
    cd /opt/matterbridge-plus && \
    curl -LO https://github.com/42wim/matterbridge-plus/releases/download/v0.3/matterbridge-plus-linux64

COPY matterbridge-plus-launch.sh /opt/matterbridge-plus/matterbridge-plus-launch.sh
COPY matterbridge.conf /opt/matterbridge-plus/matterbridge.conf
RUN chmod 755 /opt/matterbridge-plus/matterbridge-plus-launch.sh /opt/matterbridge-plus/matterbridge-plus-linux64

WORKDIR /opt/matterbridge-plus

CMD /opt/matterbridge-plus/matterbridge-plus-launch.sh
