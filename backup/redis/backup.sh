#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -e

source host_port.sh

dump() {
  host_port $(eval echo \${$1_HOST_PORT})
  local password=$(eval echo \${$1_PASSWORD})

  fp=$1/$(date "+%Y-%m-%d_%H.%M.%S").zstd
  tmp=/tmp/backup/redis.$fp
  mkdir -p $(dirname $tmp)
  docker run -e"REDISDUMPGO_AUTH=$password" \
    ghcr.io/yannh/redis-dump-go:latest \
    -host $ip -port $port | zstd -19 >$tmp

  rclone copy $tmp $RCLONE_BAK/$(dirname $fp) && rm -rf $tmp
  rclone lsjson $RCLONE_BAK/$1 | jq -r ".[].Name" | sort | head -n -5 |
    xargs -I {} rclone delete $RCLONE_BAK/$1/{}
}

for name in $REDIS_LI; do
  echo $name
  dump $name
done
