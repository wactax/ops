#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

source host_port.sh

load() {
  bucket=$RCLONE_BAK/$2.$1
  name=$(rclone lsjson $bucket | jq -r ".[].Name" | sort | tail -1)
  file=$bucket/$name
  # echo $ip $port
  tmp=/tmp/$1
  mkdir -p $tmp
  fp=$tmp/$name
  rclone copy $file $tmp
  ip=127.0.0.1 # 只对开发机做恢复
  host_port $(eval echo \${$1_HOST_PORT})
  local password=$(eval echo \${$1_PASSWORD})
  zstd -d $fp -c | redis-cli -h $ip -p $port -a $password --pipe
}

for name in $REDIS_LI; do
  echo $name
  load $name redis
done
