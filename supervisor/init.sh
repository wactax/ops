#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

etc=/etc/supervisor/supervisord.conf
if [ ! -f "$etc" ]; then
  apt-get install -y supervisor
  rsync -av ./os/ /
  rm -rf $etc
  systemctl enable --now supervisor ||
    bash -c "rsync -av ./os/ / && supervisord -c $etc"
fi
