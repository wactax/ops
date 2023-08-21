#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

curl -fsSL https://tailscale.com/install.sh | sh
tailscale login
