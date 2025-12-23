
FROM nginx:alpine AS compiler

ARG VERSION=0.14.1

RUN apk update && apk add curl tar xz

# zig-linux-aarch64-0.10.1.tar.xz
# ziglang.org/download/<ver>/zig-linux-<architecture>-<ver>.tar.xz

RUN curl https://ziglang.org/download/$VERSION/zig-$(uname -m)-linux-$VERSION.tar.xz -O && \
    tar -xf *.tar.xz && \
    mv zig-$(uname -m)-linux-$VERSION /compiler
WORKDIR /build

FROM compiler AS site

COPY publish/generate.sh /docker-entrypoint.d/90-generate.sh

VOLUME /usr/share/nginx/html
