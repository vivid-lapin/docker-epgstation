FROM --platform=$TARGETPLATFORM l3tnun/epgstation:master-alpine AS epgs-image

FROM --platform=$TARGETPLATFORM collelog/ffmpeg:4.3.1-alpine-rpi3-arm32v7 as ffmpeg-image

FROM --platform=$TARGETPLATFORM node:14-alpine
LABEL maintainer="ci7lus <7887955+ci7lus@users.noreply.github.com>"

RUN apk add --no-cache --update-cache sqlite python gcc musl

COPY --from=ffmpeg-image /build /
ENV LD_LIBRARY_PATH /opt/vc/lib

WORKDIR /app
COPY --from=epgs-image /app ./
RUN npm install --production \
    && npm prune --production \
    && npm cache clean --force
RUN rm -rf client/node_modules
RUN rm -rf \
    .dockerignore \
    .git \
    .github \
    .vscode

ENTRYPOINT [ "node", "dist/index.js" ]
EXPOSE 8888