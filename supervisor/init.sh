#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

if ! command -v supervisorctl &>/dev/null; then
  apt-get install -y supervisor
  rsync -av ./os/ /
  etc=/etc/supervisor/supervisord.conf
  rm -rf $etc
  systemctl enable --now supervisor || supervisord -c $etc
fi
