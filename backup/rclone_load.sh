#!/usr/bin/env bash
GREEN='\033[0;32m'
NC='\033[0m' # No Color

rclone_load() {
  local name=$1
  echo -e "\n${GREEN}$name${NC}\n"
  local bucket=$RCLONE_BAK/$2.$name
  local bak=$(rclone lsjson $bucket | jq -r ".[].Name" | sort | tail -1)
  local file=$bucket/$bak
  # echo $ip $port
  local tmp=/tmp/$bucket
  mkdir -p $tmp
  local fp=$tmp/$bak
  rclone copy --stats-one-line --progress $file $tmp
  $3 $fp $name # load
  rm -rf $(dirname $fp)
}
