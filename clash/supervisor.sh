#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

./init.sh
$DIR/../supervisor/init.sh
ini=clash.ini

fp=/etc/supervisor/conf.d/$ini

cp $DIR/supervisor/$ini $fp

if ! command -v cargo &>/dev/null; then
  if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
  fi
fi

rtx="$(which rtx) env"

if ! command -v sd &>/dev/null; then
  cargo install sd
fi

sd -s "\$EXE" "bash -c \"eval \\\"\$($rtx)\\\" && cd $DIR && exec $DIR/run.sh\"" $fp

supervisorctl update
sleep 3
supervisorctl status
