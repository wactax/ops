#!/usr/bin/env bash
GREEN='\033[0;32m'
NC='\033[0m' # No Color

rget() {
  if [ -f "$1" ]; then
    if [ ! -f "$1.aria2" ]; then
      return
    fi
  fi

  aria2c -x 16 -s 999 --max-tries=99 --retry-wait=1 --timeout=6 --connect-timeout=6 -o $(basename $1) -d $(dirname $1) $2
}

rclone_load() {
  local name=$1
  echo -e "\n${GREEN}$name${NC}\n"
  local bucket=$RCLONE_BAK/$name
  local json=$(rclone lsjson $bucket | jq -r ".[-1]")
  local bak=$(echo $json | jq -r ".Name")
  local tmp=/tmp/$(echo $bucket | tr -d ':')
  local fp=$tmp/$bak
  echo "→ $fp"

  bucket_bak=$bucket/$bak

  local url=https://$CDN/$name/$bak
  if [[ $(echo $json | jq -r '.IsDir') == "true" ]]; then
    mkdir -p $fp
    for i in $(rclone lsjson $bucket_bak | jq -r '.[].Path'); do
      rget $fp/$i $url/$i
    done
  else
    mkdir -p $tmp
    rget $fp $url
  fi

  load $fp $name # load
  #rm -rf $(dirname $fp)
  echo '✅ 👌'
}
