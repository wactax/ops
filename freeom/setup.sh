#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

./run.sh

cron_add '40 3 *' $DIR run.sh
