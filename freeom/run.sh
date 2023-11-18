#!/usr/bin/env bash
[ "$UID" -eq 0 ] || exec sudo "$0" "$@"
DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

if [ ! -d freenom ]; then
  git clone --depth=1 https://github.com/luolongfei/freenom.git
  cd freenom
else
  cd freenom
  git fetch --all
  git reset --hard origin/main
fi

cat ../env ./.env.example | awk -F= '!a[$1]++' >.env
docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app php:8.1 php run
