#!/usr/bin/env bash
GREEN='\033[0;32m'
NC='\033[0m' # No Color

rget='wget -P -N -c --random-wait --retry-connrefused --waitretry=5 --tries=20 -O'

rclone_load() {
  local name=$1
  echo -e "\n${GREEN}$name${NC}\n"
  local bucket=$RCLONE_BAK/$2.$name
  local bak=$(rclone lsjson $bucket | jq -r ".[].Name" | sort | tail -1)
  local tmp=/tmp/$bucket
  mkdir -p $tmp
  local fp=$tmp/$bak
  echo "→ $fp"
  $rget $fp https://$CDN/$2.$name/$bak
  $3 $fp $name # load
  rm -rf $(dirname $fp)
}
