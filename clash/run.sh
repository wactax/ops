#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

if ! [ -x "$(command -v clash)" ]; then
go install github.com/Dreamacro/clash@latest
fi

clash -f ./config.yaml
