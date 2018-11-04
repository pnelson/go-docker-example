#!/usr/bin/env sh

app="go-docker-example"
bin="/api/bin/$app"
cmd="/api/src/cmd/$app"

echo 'building...'
CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix docker -o $bin $cmd
$bin
