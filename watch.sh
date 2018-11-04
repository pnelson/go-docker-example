#!/usr/bin/env sh

find /api/src -type f -name '*.go' | entr -d -r -s /api/build.sh
