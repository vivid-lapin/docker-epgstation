FROM --platform=$TARGETPLATFORM l3tnun/epgstation:master-alpine AS epgs-image

WORKDIR /app
RUN npm install --production \
    && npm prune --production \
    && npm cache clean --force \
    && rm -rf client/node_modules

FROM --platform=$TARGETPLATFORM node:14-buster-slim
LABEL maintainer="ci7lus <7887955+ci7lus@users.noreply.github.com>"

ENV DEV="make gcc git g++ automake curl wget autoconf build-essential python python3 unzip" 

RUN apt-get update && \
    apt-get install -y $DEV && \
    apt-get install -y --no-install-recommends sqlite3 python gcc && \
    echo "deb http://archive.raspberrypi.org/debian/ buster main" > /etc/apt/sources.list.d/raspi.list && \
    gpg --keyserver hkps://pgpkeys.eu:443 --recv-key 82B129927FA3303E && \
    gpg -a --export 82B129927FA3303E| apt-key add - && \
    apt-get update && \
    apt-get -y install ffmpeg && \
    apt-get -y remove $DEV && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=epgs-image /app ./

ENTRYPOINT [ "node", "dist/index.js" ]
EXPOSE 8888