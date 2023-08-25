#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

dump() {
  local host_port=$(eval echo \${$1_HOST_PORT})
  local password=$(eval echo \${$1_PASSWORD})
  if [[ $host_port =~ \[(([0-9a-fA-F:]+))\]:([0-9]+)$ ]]; then
    # IPv6
    local ip="${BASH_REMATCH[2]}"
    local port="${BASH_REMATCH[3]}"
  elif [[ $host_port =~ ([0-9\.]+):([0-9]+)$ ]]; then
    # IPv4
    local ip="${BASH_REMATCH[1]}"
    local port="${BASH_REMATCH[2]}"
  else
    echo "$host_port Invalid Ip Format"
    return 1
  fi

  time=$(date "+%Y-%m-%d_%H.%M.%S")
  fp=/backup/redis/$1/$time.zstd
  tmp=/tmp$fp
  mkdir -p $(dirname $tmp)
  docker run -e"REDISDUMPGO_AUTH=$password" ghcr.io/yannh/redis-dump-go:latest -host $ip -port $port | zstd -19 >$tmp
  rclone copy $tmp $RCLONE_BAK$(dirname $fp)/
  rm -rf $tmp
}

dump REDIS
dump KV
dump AK
