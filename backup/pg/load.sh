#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR

set -e

source ../rclone_load.sh

name=$1
uri=$2

load() {
  fp=$1
  pv $fp | zstd -d -c | pg_restore --disable-triggers -d "postgres://$uri"
}

rclone_load $name-ol pg load
