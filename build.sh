#!/bin/bash -e
error() {
  printf '\E[31m'; echo "$@"; printf '\E[0m'
}

if [[ $EUID -ne 0 ]]; then
    error "This script should be run using sudo or as the root user"
    exit 1
fi

export TAG=${1:-latest}
export ARCH=${2:-"$(uname -m)"}

if [ -f ./build.env ]; then
	set -a
	source ./build.env
	set +a
fi
REGISTRY=${REGISTRY:-mochoa}/
PUSH=${PUSH:-true}
env

build() {
    if [ $ARCH == "armv7l" ]
    then
        BPLATFORM="linux/arm/v7"
    else if [ $ARCH == "aarch64" ] 
        then
            BPLATFORM="linux/arm64"
        else
            BPLATFORM="linux/amd64"
        fi
    fi
    if [ $ARCH == "x86_64" ]
    then
        docker plugin rm -f ${REGISTRY}$1:$TAG || true
    else
        docker plugin rm -f ${REGISTRY}$1-$ARCH:$TAG || true
    fi
    docker rmi -f rootfsimage || true
    docker buildx build --load --platform ${BPLATFORM} \
        --build-arg GO_VERSION=${GO_VERSION:-1.15.10} \
        --build-arg UBUNTU_VERSION=${UBUNTU_VERSION:-20.04} \
        --build-arg PLUGIN_VERSION="${PLUGIN_VERSION}" \
        --build-arg BUILD_DATE="$(date +"%Y-%m-%dT%H:%M:%SZ")" \
        -t rootfsimage -f $1/Dockerfile .
    id=$(docker create rootfsimage true) # id was cd851ce43a403 when the image was created
    rm -rf build/rootfs
    mkdir -p build/rootfs/var/lib/docker-volumes
    docker export "$id" | tar -x -C build/rootfs
    docker rm -vf "$id"
    cp $1/config.json build
    if [ $ARCH == "x86_64" ]
    then
        docker plugin create ${REGISTRY}$1:$TAG build
        [ "$PUSH" == "true" ] && docker plugin push ${REGISTRY}$1:$TAG
    else
        docker plugin create ${REGISTRY}$1-$ARCH:$TAG build
        [ "$PUSH" == "true" ] && docker plugin push ${REGISTRY}$1-$ARCH:$TAG
    fi
}
build glusterfs-volume-plugin
build s3fs-volume-plugin
build cifs-volume-plugin
