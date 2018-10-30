ARG METEOR_VERSION=1.6.1
FROM staeke/meteor-alpine:slim-mongo-$METEOR_VERSION

# Add edge/edgecommunity to get a decently recent Chrome even on Alpine:[notlatest]. Also upgrade apk-tools
# See https://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management for details
RUN echo @edgecommunity http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories && \
    echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories && \
    apk add --update apk-tools@edge && \
    apk add --update --upgrade apk-tools@edge

# Dependencies taken from https://github.com/GoogleChrome/puppeteer/issues/3019
RUN apk add --no-cache \
        chromium@edgecommunity \
        chromium-chromedriver@edgecommunity \
        nss@edge \
        freetype@edge \
        harfbuzz@edge &&\
    rm -rf /var/lib/apt/lists/* \
        /var/cache/apk/* \
        /usr/share/man \
        /tmp/*

ENV CHROMEDRIVER_BIN=/usr/bin/chromedriver
ENV CHROME_BIN=/usr/bin/chromium-browser