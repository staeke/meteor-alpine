ARG NODE_VERSION
FROM node:$NODE_VERSION-alpine
ARG METEOR_VERSION
ARG METEOR_NODE_VERSION
ARG NODE_VERSION

ENV METEOR_ALLOW_SUPERUSER=1

# setup a more secure way of running meteor commands, by a meteor user
# by specifiying a known uid the docker container can be setup with right permissions for any volume mounts
RUN adduser -D -u 1001 -h /home/meteor meteor

# bash is needed by many meteor commands - leave on machine
RUN apk add --update --no-cache bash

# 1. Install temp packages needed for build
# 2. Install meteor for user meteor (with launcher creation)
# 3. Assert node version bundled is what we think it should be
# 4. Relink node/npm/npx to the versions already on the image - built for Alpine
# 5. Make npm modules work on Alpine (netroute has an odd bug that we have to hack around)
# 6. Make meteor available to root user (beyond meteor user)
# 7. Remove temp packages
RUN export TEMP_PACKAGES="alpine-sdk libc6-compat python linux-headers" && \
    apk add --update --no-cache $TEMP_PACKAGES && \
    su - meteor -c "curl https://install.meteor.com/?release=${METEOR_VERSION} | sh" && \
    cd /home/meteor/.meteor/packages/meteor-tool/*/mt-os.linux.x86_64 && \
    cp scripts/admin/launch-meteor /usr/bin/meteor && \
    cd dev_bundle && \
    echo Meteor bundled node version: $(cat .bundle_version.txt), expected: ${METEOR_NODE_VERSION} && \
    (cat .bundle_version.txt | grep $METEOR_NODE_VERSION > /dev/null) && \
    cd bin && \
    rm node  && \
    rm npm && \
    rm npx && \
    ln -s $(which node) && \
    ln -s $(which npm) && \
    ln -s $(which npx) && \
    cd ../mongodb/bin && \
    rm mongo mongod && \
    cd ../../lib && \
    sed -i '/sysctl\.h/d' node_modules/netroute/src/netroute.cc && \
    npm rebuild && \
    cd ~ && \
    ln -s /home/meteor/.meteor && \
    apk del $TEMP_PACKAGES

WORKDIR home/meteor