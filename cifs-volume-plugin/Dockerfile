ARG UBUNTU_VERSION
ARG GO_VERSION
ARG PLUGIN_VERSION
ARG BUILD_DATE

FROM --platform=${TARGETPLATFORM:-linux/amd64} ubuntu:${UBUNTU_VERSION:-24.04} AS base

ENV DEBIAN_FRONTEND="noninteractive"
ENV UBUNTU_VERSION="${UBUNTU_VERSION:-24.04}"
ENV GO_VERSION="${GO_VERSION:-1.23}"
ENV PLUGIN_VERSION="${PLUGIN_VERSION}"
ENV BUILD_DATE="${BUILD_DATE}"

RUN apt update && \
    apt install -y cifs-utils curl tini && \
    apt clean && rm -rf /var/lib/apt/lists/*

ARG GO_VERSION

FROM --platform=${TARGETPLATFORM:-linux/amd64} golang:${GO_VERSION:-1.23}-alpine AS dev

RUN apk update && apk add git

COPY cifs-volume-plugin/ /go/src/github.com/marcelo-ochoa/docker-volume-plugins/cifs-volume-plugin
COPY mounted-volume/ /go/src/github.com/marcelo-ochoa/docker-volume-plugins/mounted-volume

RUN cd /go/src/github.com/marcelo-ochoa/docker-volume-plugins/cifs-volume-plugin && \
    CGO_ENABLED=0 GOOS=linux GOPRIVATE=github.com/marcelo-ochoa/* go install github.com/marcelo-ochoa/docker-volume-plugins/cifs-volume-plugin@latest

FROM base

COPY --from=dev /go/bin/cifs-volume-plugin /

ARG UBUNTU_VERSION
ARG GO_VERSION
ARG GLUSTERFS_VERSION
ARG PLUGIN_VERSION
ARG BUILD_DATE

LABEL   \
        org.opencontainers.image.created=${BUILD_DATE} \
        org.opencontainers.image.version=${PLUGIN_VERSION} \
        org.opencontainers.image.source=https://github.com/marcelo-ochoa/docker-volume-plugins \
        org.opencontainers.image.description="CIFS Volume Plugin ${PLUGIN_VERSION} based on Ubuntu ${UBUNTU_VERSION} and Golang v${GO_VERSION}." \
        org.opencontainers.image.ref.name="ubuntu:${UBUNTU_VERSION}"
