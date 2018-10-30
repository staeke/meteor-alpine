ARG METEOR_VERSION
FROM staeke/meteor-alpine:${METEOR_VERSION}-slim-mongo
RUN apk add --no-cache git