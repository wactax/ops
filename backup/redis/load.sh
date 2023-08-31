#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR

case $(uname -s) in
Linux*)
  echo "为避免误操作，不在 Linux 上运行"
  exit 0
  ;;
esac

source host_port.sh

set -ex

load() {
  bucket=$RCLONE_BAK/$2.$1
  name=$(rclone lsjson $bucket | jq -r ".[].Name" | sort | tail -1)
  file=$bucket/$name
  # echo $ip $port
  tmp=/tmp/$1
  mkdir -p $tmp
  fp=$tmp/$name
  rclone copy $file $tmp
  echo $fp
}

for name in $REDIS_LI; do
  echo $name
  fp=$(load $name redis)
  host_port $(eval echo \${${name}_HOST_PORT})
  ip=127.0.0.1 # 只对开发机做恢复
  password=$(eval echo \${${name}_PASSWORD})
  zstd -d $fp -c | redis-cli -h $ip -p $port -a $password --pipe
done
