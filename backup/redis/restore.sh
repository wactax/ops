#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -e

source host_port.sh

load() {
  host_port $(eval echo \${$1_HOST_PORT})
  name=$(rclone lsjson $RCLONE_BAK/$1 | jq -r ".[].Name" | tail -1)
  echo $name
  echo $ip $port
  # redis-cli -h 127.0.0.1 -p 9970 -a $REDIS_PASSWORD --pipe $1
}

for name in $REDIS_LI; do
  echo $name
  load $name
done
