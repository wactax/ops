#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

cron_add "$((RANDOM % 60)) $((RANDOM % 23)) *" $DIR ./snapshot.sh
