ARG UBUNTU_VERSION
ARG GO_VERSION
ARG PLUGIN_VERSION
ARG BUILD_DATE
FROM --platform=${TARGETPLATFORM:-linux/amd64} ubuntu:${UBUNTU_VERSION:-20.04} as base

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt update && \
    apt install -y software-properties-common && \
    add-apt-repository ppa:gluster/glusterfs-10 && \
    apt install -y glusterfs-client curl rsyslog tini && \
    apt clean && rm -rf /var/lib/apt/lists/* && \
    rm -rf "/tmp/*" "/root/.cache" /var/log/lastlog && \
    mkdir -p /var/lib/glusterd /etc/glusterfs && \
    touch /etc/glusterfs/logger.conf

COPY glusterfs-volume-plugin/rsyslog.conf /etc/rsyslog.conf

ARG GO_VERSION
FROM --platform=${TARGETPLATFORM:-linux/amd64} golang:${GO_VERSION:-1.15.10}-alpine as dev

RUN apk update && apk add git

COPY glusterfs-volume-plugin/ /go/src/github.com/marcelo-ochoa/docker-volume-plugins/glusterfs-volume-plugin
COPY mounted-volume/ /go/src/github.com/marcelo-ochoa/docker-volume-plugins/mounted-volume

RUN cd /go/src/github.com/marcelo-ochoa/docker-volume-plugins/glusterfs-volume-plugin && \
    CGO_ENABLED=0 GOOS=linux GOPRIVATE=github.com/marcelo-ochoa/* go install github.com/marcelo-ochoa/docker-volume-plugins/glusterfs-volume-plugin@latest

FROM base

COPY --from=dev /go/bin/glusterfs-volume-plugin /

LABEL   \
        org.opencontainers.image.created=${BUILD_DATE} \
        org.opencontainers.image.version=${PLUGIN_VERSION} \
        org.opencontainers.image.source=https://github.com/marcelo-ochoa/docker-volume-plugins \
        org.opencontainers.image.description="GlusterFS Volume Plugin v${PLUGIN_VERSION} based on Ubuntu ${UBUNTU_VERSION} and Golang v${GO_VERSION}."
