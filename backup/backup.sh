#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

./pg/backup.sh &
./redis/backup.sh &
wait
