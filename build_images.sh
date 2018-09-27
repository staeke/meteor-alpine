#!/usr/bin/env bash
# 1.6.0.1/8.9.8/8.9.3
# 1.6.1/8.9.18/8.9.4
# 1.6.1.1/8.11.1/8.11.1
# 1.7/8.11.2/8.11.2
# 1.7.0.1/8.11.2/8.11.2
# 1.7.0.2/8.11.3/8.11.3
# 1.7.0.3/8.11.3/8.11.3
# 1.7.0.4/8.11.3/8.11.3
# 1.7.0.5/8.11.3/8.11.3

set -e

export METEOR_VERSION=1.7.0.4
export METEOR_NODE_VERSION=8.11.3 # For some reason this sometimes differs from NODE_VERSION, and in weird ways
export NODE_VERSION=8.11.3
docker build -f meteor-alpine.Dockerfile \
    --build-arg METEOR_VERSION=${METEOR_VERSION} \
    --build-arg NODE_VERSION=${NODE_VERSION} \
    --build-arg METEOR_NODE_VERSION=${METEOR_NODE_VERSION} \
    . -t staeke/meteor-alpine:${METEOR_VERSION}
docker push staeke/meteor-alpine:${METEOR_VERSION}

docker build -f meteor-node-alpine.Dockerfile \
    --build-arg NODE_VERSION=${NODE_VERSION} \
    . -t staeke/meteor-node-alpine:${METEOR_VERSION}
docker push staeke/meteor-node-alpine:${METEOR_VERSION}

