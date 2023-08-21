#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

if [ ! -d "/mnt/backup" ]; then
  git clone git@github.com:wacbk/backup.git /mnt/backup
fi

cron_add '3 1 *' $DIR backup.sh
