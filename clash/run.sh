#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

if ! command -v cargo &>/dev/null; then
  if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
  fi
fi

if ! [ -x "$(command -v clash)" ]; then
  if ! command -v go &>/dev/null; then
    command -v rtx &>/dev/null && eval $(rtx env)
  fi
  if ! command -v go &>/dev/null; then
    rtx install go
  fi
  if ! [ -x "$(command -v clash)" ]; then
    go install github.com/Dreamacro/clash@latest
  fi
fi

clash -f ./clash.yml
