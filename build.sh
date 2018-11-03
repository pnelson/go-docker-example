#!/usr/bin/env sh

docker-compose build --build-arg UID=$(id -u) --build-arg GID=$(id -g)
docker-compose up
