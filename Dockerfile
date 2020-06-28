FROM alpine

ENTRYPOINT ["/opt/syncthing", "-gui-address", "http://0.0.0.0:8080"]

EXPOSE 8080

ENV SYNCTHING_VERSION=1.6.1 \
    HOME=/home

RUN chmod 777 /home

RUN apk add --no-cache --virtual .build-deps \
    curl \
    ca-certificates \
 && cd /opt \
 && arch="$(if [ "$(uname -m)" = "aarch64" ]; then echo "arm64"; else uname -m; fi)" \
 && curl -L https://github.com/syncthing/syncthing/releases/download/v${SYNCTHING_VERSION}/syncthing-linux-$arch-v${SYNCTHING_VERSION}.tar.gz \
  | tar zx syncthing-linux-$arch-v${SYNCTHING_VERSION}/syncthing \
 && apk del .build-deps \
 && mv syncthing-linux-$arch-v${SYNCTHING_VERSION}/syncthing /opt \
 && rmdir syncthing-linux-$arch-v${SYNCTHING_VERSION}
