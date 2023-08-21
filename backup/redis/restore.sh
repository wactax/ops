#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

redis-cli -h 127.0.0.1 -p 9970 -a $REDIS_PASSWORD --pipe <kvdb
