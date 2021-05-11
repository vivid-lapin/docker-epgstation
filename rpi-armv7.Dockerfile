FROM --platform=$TARGETPLATFORM l3tnun/epgstation:v2.3.2-debian AS epgs-image

WORKDIR /app
RUN rm -rf client/node_modules

FROM --platform=$TARGETPLATFORM node:14-buster-slim
LABEL maintainer="ci7lus <7887955+ci7lus@users.noreply.github.com>"

ENV DEV="gcc g++ build-essential python" 

WORKDIR /app

RUN apt-get update && \
    apt-get install -y $DEV && \
    apt-get install -y --no-install-recommends sqlite3 ca-certificates && \
    echo "deb http://archive.raspberrypi.org/debian/ buster main" > /etc/apt/sources.list.d/raspi.list && \
    gpg --keyserver hkps://pgpkeys.eu:443 --recv-key 82B129927FA3303E && \
    gpg -a --export 82B129927FA3303E| apt-key add - && \
    apt-get update && \
    apt-get -y install ffmpeg && \
    apt-get -y remove $DEV && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
COPY --from=epgs-image /app ./

ENTRYPOINT [ "node", "dist/index.js" ]
EXPOSE 8888