#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

BKDIR=$BACKUP/crontab
mkdir -p $BKDIR
cd $BKDIR

git pull -f || git reset --hard origin/main
txt=$(hostname).txt

crontab -l >$txt
git add $txt
git add -u
git commit -m"$hostname crontab backup" || exit 0
git push
