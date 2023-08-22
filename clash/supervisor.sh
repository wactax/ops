#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

ini=clash.ini

fp=/etc/supervisor/conf.d/$ini

cp $DIR/supervisor/$ini $fp

rtx="$(which rtx) env"

sd -s "\$EXE" "bash -c \"eval \\\"\$($rtx)\\\" && cd $DIR && exec $DIR/run.sh\"" $fp

supervisorctl update
sleep 3
supervisorctl status
