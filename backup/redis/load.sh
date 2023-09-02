#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR

set -e

case $(uname -s) in
Linux*)
  echo "为避免误操作，不在 Linux 上运行"
  exit 0
  ;;
esac

source host_port.sh
source ../rclone_load.sh

load() {
  fp=$1
  name=$2
  host_port $(eval echo \${${name}_HOST_PORT})
  ip=127.0.0.1 # 只对开发机做恢复
  password=$(eval echo \${${name}_PASSWORD})
  pv $fp | zstd -d -c | redis-cli -h $ip -p $port -a $password --pipe
}

for name in $REDIS_LI; do
  rclone_load redis $name load
done
