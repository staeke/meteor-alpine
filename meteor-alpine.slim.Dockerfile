ARG NODE_VERSION
FROM node:$NODE_VERSION-alpine
ARG METEOR_VERSION
ARG METEOR_NODE_VERSION
ARG NODE_VERSION

ENV METEOR_ALLOW_SUPERUSER=1

# Update system
RUN apk update && apk upgrade 

# setup a more secure way of running meteor commands, by a meteor user
# by specifiying a known uid the docker container can be setup with right permissions for any volume mounts
RUN adduser -D -u 1001 -h /home/meteor meteor

# bash is needed by many meteor commands - leave on machine
RUN apk add --update --no-cache bash


RUN export TEMP_PACKAGES="alpine-sdk libc6-compat python linux-headers" && \
    \
    echo 'Install temp packages needed for build' && \
    apk add --update --no-cache $TEMP_PACKAGES && \
    \
    echo 'Install meteor for user meteor (with launcher creation as recommended by meteor)' && \
    su - meteor -c "curl https://install.meteor.com/?release=${METEOR_VERSION} | sh" && \
    cd /home/meteor/.meteor/packages/meteor-tool/*/mt-os.linux.x86_64 && \
    cp scripts/admin/launch-meteor /usr/bin/meteor && \
    \
    echo 'Assert node version bundled is what we think it should be' && \
    cd dev_bundle && \
    echo Meteor bundled node version: $(cat .bundle_version.txt), expected: ${METEOR_NODE_VERSION} && \
    (cat .bundle_version.txt | grep $METEOR_NODE_VERSION > /dev/null) && \
    \
    echo 'Relink node/npm/npx to the versions already on the image - built for Alpine' && \
    cd bin && \
    rm node  && \
    rm npm && \
    rm npx && \
    ln -s $(which node) && \
    ln -s $(which npm) && \
    ln -s $(which npx) && \
    cd .. && \
    \
    echo 'Remove bundled mongo since it is not working on Alpine. Other images built on this will provide mongo.' && \
    cd mongodb/bin && \
    rm mongo mongod && \
    cd ../.. && \
    \
    echo 'Make npm modules work on Alpine. First - fix bug in netroute' && \
    cd lib && \
    sed -i '/sysctl\.h/d' node_modules/netroute/src/netroute.cc && \
    npm rebuild && \
    cd .. && \
    \
    echo 'For alpine we must use fibers@3.0.0 which requires @babel/runtime. Fix' && \
    mkdir temp && \
    cd temp && \
    npm init -y && \
    npm install fibers@2.0.2 && \
    cd .. && \
    rm -rf lib/node_modules/fibers && \
    cp -R temp/node_modules/fibers lib/node_modules/ && \
    cp -R temp/node_modules/fibers server-lib/node_modules/ && \
    cp -R lib/node_modules/\@babel server-lib/node_modules/ && \
    rm -rf temp && \
    \
    echo 'Make meteor available to root user (beyond meteor user)' && \
    cd ~ && \
    ln -s /home/meteor/.meteor && \
    \
    echo 'Remove temporary build packages' && \
    apk del $TEMP_PACKAGES

WORKDIR home/meteor