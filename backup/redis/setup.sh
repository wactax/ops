#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

cron_add '0 20 *' $DIR ./run.sh
