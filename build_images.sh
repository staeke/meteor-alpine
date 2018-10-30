!/usr/bin/env bash
set -e

build_images() {
    docker build -f meteor-alpine.slim.Dockerfile \
        --build-arg METEOR_VERSION=${METEOR_VERSION} \
        --build-arg NODE_VERSION=${NODE_VERSION} \
        --build-arg METEOR_NODE_VERSION=${METEOR_NODE_VERSION} \
        . -t staeke/meteor-alpine:${METEOR_VERSION}-slim
    docker push staeke/meteor-alpine:${METEOR_VERSION}-slim

    docker build -f meteor-alpine.slim-mongo.Dockerfile \
        --build-arg METEOR_VERSION=${METEOR_VERSION} \
        . -t staeke/meteor-alpine:${METEOR_VERSION}-slim-mongo
    docker push staeke/meteor-alpine:${METEOR_VERSION}-slim-mongo

    docker build -f meteor-alpine.Dockerfile \
        --build-arg METEOR_VERSION=${METEOR_VERSION} \
        . -t staeke/meteor-alpine:${METEOR_VERSION}
    docker push staeke/meteor-alpine:${METEOR_VERSION}

    docker build -f meteor-node-alpine.Dockerfile \
        --build-arg NODE_VERSION=${NODE_VERSION} \
        . -t staeke/meteor-node-alpine:${METEOR_VERSION}
    docker push staeke/meteor-node-alpine:${METEOR_VERSION}
}

export METEOR_VERSION=1.6.0.1; export METEOR_NODE_VERSION=8.9.8; export NODE_VERSION=8.9.3; build_images
export METEOR_VERSION=1.6.1; export METEOR_NODE_VERSION=8.9.18; export NODE_VERSION=8.9.4; build_images
export METEOR_VERSION=1.6.1.1; export METEOR_NODE_VERSION=8.11.1; export NODE_VERSION=8.11.1; build_images
export METEOR_VERSION=1.6.1.2; export METEOR_NODE_VERSION=8.11.1; export NODE_VERSION=8.11.1; build_images
export METEOR_VERSION=1.6.1.3; export METEOR_NODE_VERSION=8.11.1; export NODE_VERSION=8.11.1; build_images
export METEOR_VERSION=1.6.1.4; export METEOR_NODE_VERSION=8.11.1; export NODE_VERSION=8.11.1; build_images
export METEOR_VERSION=1.7; export METEOR_NODE_VERSION=8.11.2; export NODE_VERSION=8.11.2; build_images
export METEOR_VERSION=1.7.0.1; export METEOR_NODE_VERSION=8.11.2; export NODE_VERSION=8.11.2; build_images
export METEOR_VERSION=1.7.0.2; export METEOR_NODE_VERSION=8.11.3; export NODE_VERSION=8.11.3; build_images
export METEOR_VERSION=1.7.0.3; export METEOR_NODE_VERSION=8.11.3; export NODE_VERSION=8.11.3; build_images
export METEOR_VERSION=1.7.0.4; export METEOR_NODE_VERSION=8.11.3; export NODE_VERSION=8.11.3; build_images
export METEOR_VERSION=1.7.0.5; export METEOR_NODE_VERSION=8.11.4; export NODE_VERSION=8.11.4; build_images
export METEOR_VERSION=1.8; export METEOR_NODE_VERSION=8.11.4; export NODE_VERSION=8.11.4; build_images

