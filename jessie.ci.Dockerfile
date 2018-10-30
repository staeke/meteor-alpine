FROM debian:jessie
ARG METEOR_VERSION=1.6.1

# Permanent packages - needed by Meteor
RUN apt-get update -y && \
    apt-get install -y curl bash

RUN curl https://install.meteor.com/?release=$METEOR_VERSION | sh

# Other packages that are handy, but that we technically don't need to *have* on the image
RUN apt-get update -y && \
    apt-get install -y apt-transport-https wget lsof

# Make Meteor's node,npm,npx globallly available
RUN cd /usr/bin && \
	ln -s /root/.meteor/packages/meteor-tool/*/mt-os.linux.x86_64/dev_bundle/bin/node && \
	ln -s /root/.meteor/packages/meteor-tool/*/mt-os.linux.x86_64/dev_bundle/bin/npm && \
	ln -s /root/.meteor/packages/meteor-tool/*/mt-os.linux.x86_64/dev_bundle/bin/npx

# Install yarn, handy for checking npm modules
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
	apt-get update -y && \
	apt-get install -y yarn

# Install Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
	echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list && \
	apt-get update -y && \
	apt-get -y install google-chrome-stable

ENV METEOR_ALLOW_SUPERUSER=1

