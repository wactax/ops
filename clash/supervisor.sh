#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

$DIR/../supervisor/init.sh
ini=clash.ini

fp=/etc/supervisor/conf.d/$ini

cp $DIR/supervisor/$ini $fp

rtx="$(which rtx) env"

if ! command -v sd &>/dev/null; then
  cargo install sd
fi

sd -s "\$EXE" "bash -c \"eval \\\"\$($rtx)\\\" && cd $DIR && exec $DIR/run.sh\"" $fp

supervisorctl update
sleep 3
supervisorctl status
