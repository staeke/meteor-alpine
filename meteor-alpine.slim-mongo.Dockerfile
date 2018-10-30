ARG METEOR_VERSION
FROM staeke/meteor-alpine:$METEOR_VERSION-slim
RUN apk add --no-cache mongodb
RUN cd /home/meteor/.meteor/packages/meteor-tool/*/mt-os.linux.x86_64/dev_bundle/mongodb/bin && \
	ln -s $(which mongo) && \
	ln -s $(which mongod) 