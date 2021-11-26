FROM alpine

ENTRYPOINT ["/opt/syncthing", "-gui-address", "http://0.0.0.0:8080"]

EXPOSE 8080

ENV SYNCTHING_VERSION=1.18.4 \
    HOME=/home

RUN chmod 777 /home

RUN apk add --no-cache --virtual .build-deps \
    curl \
    ca-certificates \
 && cd /opt \
 && arch="$(case "$(uname -m)" in "aarch64") echo "arm64" ;; "x86_64") echo "amd64" ;; "armv7l") echo "arm" ;; *) uname -m ;; esac)" \
 && echo "Building for $arch" \
 && curl -L https://github.com/syncthing/syncthing/releases/download/v${SYNCTHING_VERSION}/syncthing-linux-$arch-v${SYNCTHING_VERSION}.tar.gz \
  | tar zx syncthing-linux-$arch-v${SYNCTHING_VERSION}/syncthing \
 && apk del .build-deps \
 && mv syncthing-linux-$arch-v${SYNCTHING_VERSION}/syncthing /opt \
 && rmdir syncthing-linux-$arch-v${SYNCTHING_VERSION}
