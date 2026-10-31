
FROM nginx:alpine AS compiler

ARG VERSION=0.16.0

RUN apk update && apk add curl tar xz gnupg

RUN curl https://mirrors.qsmally.org/zig/zig-$(uname -m)-linux-$VERSION.tar.xz -O && \
    tar -xf *.tar.xz && \
    mv zig-$(uname -m)-linux-$VERSION /compiler
WORKDIR /build

FROM compiler AS site

RUN mkdir -p /root/.gnupg && \
    chmod 700 /root/.gnupg && \
    touch /root/.gnupg/common.conf

COPY publish/generate.sh /docker-entrypoint.d/90-generate.sh

VOLUME /usr/share/nginx/html
