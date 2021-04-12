FROM --platform=$TARGETPLATFORM l3tnun/epgstation:master-alpine AS epgs-image

FROM collelog/ffmpeg:4.3.1-alpine-rpi3 as ffmpeg-image

FROM --platform=$TARGETPLATFORM node:14-alpine

RUN apk add --update sqlite python3 gcc

COPY --from=ffmpeg-image /build /usr/local/bin

WORKDIR /app
COPY --from=epgs-image /app ./
RUN npm install --production && npm prune --production
RUN rm -rf \
    .dockerignore \
    .git \
    .github \
    .vscode

ENTRYPOINT [ "node", "dist/index.js" ]
EXPOSE 8888