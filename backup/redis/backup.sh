#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -e

source host_port.sh

dump() {
  host_port $(eval echo \${$1_HOST_PORT})
  local password=$(eval echo \${$1_PASSWORD})

  tmp=/tmp/backup/redis.$1/$(date "+%Y-%m-%d_%H.%M.%S").zstd
  mkdir -p $(dirname $tmp)
  docker run -e"REDISDUMPGO_AUTH=$password" \
    ghcr.io/yannh/redis-dump-go:latest \
    -host $ip -port $port | zstd -19 >$tmp

  ../rclone_cp.sh $tmp redis.$1
}

for name in $REDIS_LI; do
  echo $name
  dump $name
done
