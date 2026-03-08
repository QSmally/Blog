
all: build run

build: zig-out/.docker

zig-out/.docker:
	docker build -t blog .
	touch zig-out/.docker

run:
	docker run \
		--rm \
		-v "$(shell pwd):/usr/share/nginx/html" \
		-v "$(shell pwd)/nginx/conf.d:/etc/nginx/conf.d" \
		-p 80:80 \
		blog
