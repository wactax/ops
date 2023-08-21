#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

docker run -e"REDISDUMPGO_AUTH=$REDIS_PASSWORD" ghcr.io/yannh/redis-dump-go:latest -host $REDIS_HOST -port $REDIS_PORT
