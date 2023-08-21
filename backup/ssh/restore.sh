#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Usage: $0 hostname"
  exit 1
fi

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

if [ ! -d "ssh" ]; then
  git clone --depth=1 git@github.com:ol-conf/ssh.git
fi

cd ssh

rsync --perms --chown=root -avz $1/root/ $1:/root/
