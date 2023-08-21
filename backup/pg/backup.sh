#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR

set -o allexport
source ./.env
set +o allexport
./src/main.coffee
./data.coffee
