#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

if ! command -v supervisorctl &>/dev/null; then
  apt-get install -y supervisor
  rsync -av ./os/ /
  systemctl enable --now supervisor || supervisord
fi
