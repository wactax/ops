#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR

set -e

source ../rclone_load.sh

name=$1
uri=$2
schema=$3

load() {
  fp=$1
  for s in $schema; do
    pv $fp/$s.zstd | zstd -d -c | pg_restore --disable-triggers -d "$uri"
  done
}

rclone_load $name pg load
