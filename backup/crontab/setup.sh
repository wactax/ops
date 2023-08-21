#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

direnv allow
cron_add '3 1 *' $DIR backup.sh
