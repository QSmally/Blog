#!/bin/sh

set -e

cd /usr/share/nginx/html
/compiler/zig build gen -Doptimize=ReleaseSafe
