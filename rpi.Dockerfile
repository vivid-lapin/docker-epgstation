FROM l3tnun/epgstation:master-debian AS EPGStation-image

FROM --platform=$TARGETPLATFORM node:14-buster-slim
EXPOSE 8888
ENV DEV="make gcc git g++ automake curl wget autoconf build-essential python python3 unzip" 

RUN apt-get update && \
    apt-get -y install $DEV && \
    apt-get -y install rsync nkf sqlite3

# install hardware acceleration ffmpeg
RUN echo "deb http://archive.raspberrypi.org/debian/ buster main" > /etc/apt/sources.list.d/raspi.list && \
    gpg --keyserver hkps://pgpkeys.eu:443 --recv-key 82B129927FA3303E && \
    gpg -a --export 82B129927FA3303E| apt-key add - && \
    apt-get update && \
    apt-get -y install ffmpeg

WORKDIR /app
COPY --from=EPGStation-image /app ./
RUN rm -rf \
    .dockerignore \
    .git \
    .github \
    .vscode

RUN apt-get -y remove $DEV && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "node", "dist/index.js" ]
