FROM --platform=$TARGETPLATFORM l3tnun/epgstation:master-alpine AS epgs-image

FROM --platform=$TARGETPLATFORM collelog/ffmpeg:4.3.1-alpine-rpi3-arm32v7 as ffmpeg-image

FROM --platform=$TARGETPLATFORM node:14-alpine

RUN apk add --no-cache --update-cache sqlite python gcc musl

COPY --from=ffmpeg-image /build /

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