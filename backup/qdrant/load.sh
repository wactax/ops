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

source ../rclone_load.sh

#nc -z -w 1 127.0.0.1 7890 && export https_proxy=http://127.0.0.1:7890

load() {
  fp=$1
  name=$2
  echo $fp $name
  #   host_port $(eval echo \${${name}_HOST_PORT})
  #   ip=127.0.0.1 # 只对开发机做恢复
  #   password=$(eval echo \${${name}_PASSWORD})
  # pv $fp | zstd -d -c >$DIR/snapshots/$name.$(echo $(basename $fp) | sed 's/\.[^\.]*$//')
  # exit 1
}

rclone_load qdrant
