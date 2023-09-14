#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
bak() {
  cd $DIR/$1
  direnv allow
  direnv exec . ./backup.sh
}
set -ex
bak redis
bak pg
bak greptime
