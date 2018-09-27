ARG NODE_VERSION
FROM node:$NODE_VERSION-alpine
CMD []
# setup a more secure way of running meteor commands, by a meteor user
# by specifiying a known uid the docker container can be setup with right permissions for any volume mounts
RUN adduser -D -u 1001 -h /home/meteor meteor