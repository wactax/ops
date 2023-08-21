#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR

if [ -f '.env' ]; then
  set -a
  source .env
  set +a
fi

set -ex
exec direnv exec . ./main.js
