#!/usr/bin/env sh

bin="/dist/bin"
cmd="/build/cmd/go-docker-example"

echo "user: $(id -u):$(id -g)"
find /dist -type f -print
find /build -type f -name 'go.*' -print
find /build -type f -name '*.go' -print | sort -u

find /build -type f -name '*.go' | entr -r "CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix docker -o $bin $cmd && $bin"
