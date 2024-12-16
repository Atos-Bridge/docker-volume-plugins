ARG UBUNTU_VERSION
ARG GO_VERSION
ARG PLUGIN_VERSION
ARG BUILD_DATE
FROM --platform=${TARGETPLATFORM:-linux/amd64} ubuntu:${UBUNTU_VERSION:-24.04} AS base

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt update && \
    apt install -y s3fs curl rsyslog tini && \
    mkdir -p /var/lib/rsyslog && \
    apt clean && rm -rf /var/lib/apt/lists/*

COPY s3fs-volume-plugin/rsyslog.conf /etc/rsyslog.conf
COPY s3fs-volume-plugin/fuse.conf /etc/fuse.conf

FROM --platform=${TARGETPLATFORM:-linux/amd64} golang:${GO_VERSION:-1.23}-alpine AS dev

RUN apk update && apk add git

COPY s3fs-volume-plugin/ /go/src/github.com/marcelo-ochoa/docker-volume-plugins/s3fs-volume-plugin
COPY mounted-volume/ /go/src/github.com/marcelo-ochoa/docker-volume-plugins/mounted-volume

RUN cd /go/src/github.com/marcelo-ochoa/docker-volume-plugins/s3fs-volume-plugin && \
    CGO_ENABLED=0 GOOS=linux GOPRIVATE=github.com/marcelo-ochoa/* go install github.com/marcelo-ochoa/docker-volume-plugins/s3fs-volume-plugin@latest

FROM base

COPY --from=dev /go/bin/s3fs-volume-plugin /

LABEL   \
        org.opencontainers.image.created=${BUILD_DATE} \
        org.opencontainers.image.version=${PLUGIN_VERSION} \
        org.opencontainers.image.source=https://github.com/marcelo-ochoa/docker-volume-plugins \
        org.opencontainers.image.description="S3FS Volume Plugin v${PLUGIN_VERSION} based on Ubuntu ${UBUNTU_VERSION:-24.04} and Golang v${GO_VERSION:-1.23}."
