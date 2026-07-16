
FROM nginx:alpine AS compiler

ARG VERSION=0.16.0

RUN apk update && apk add curl tar xz

RUN curl https://mirrors.qsmally.org/zig/zig-$(uname -m)-linux-$VERSION.tar.xz -O && \
    tar -xf *.tar.xz && \
    mv zig-$(uname -m)-linux-$VERSION /compiler
WORKDIR /build

FROM compiler AS site

COPY publish/generate.sh /docker-entrypoint.d/90-generate.sh

VOLUME /usr/share/nginx/html
