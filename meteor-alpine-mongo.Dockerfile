ARG METEOR_VERSION=1.6.1
ARG MONGO_VERSION=3.4
FROM staeke/meteor-alpine:$METEOR_VERSION
RUN cd /home/meteor/.meteor/packages/meteor-tool/*/mt-os.linux.x86_64/dev_bundle/mongodb/bin
