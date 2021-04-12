FROM l3tnun/epgstation:master-debian AS epgs-image

FROM collelog/ffmpeg:4.3.1-alpine-arm32v7 as ffmpeg-image

FROM --platform=$TARGETPLATFORM node:14-alpine

COPY --from=ffmpeg-image /build /usr/local/bin

WORKDIR /app
COPY --from=epgs-image /app ./
RUN rm -rf \
    .dockerignore \
    .git \
    .github \
    .vscode

ENTRYPOINT [ "node", "dist/index.js" ]
