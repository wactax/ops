#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

BKDIR=$BACKUP/crontab
mkdir -p $BKDIR

txt=$(hostname).txt
crontab -l >$BKDIR/$txt
cd $BKDIR
git add $txt
git add -u
git commit -m"$hostname crontab backup" && git push
