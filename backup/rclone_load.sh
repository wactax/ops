#!/usr/bin/env bash
GREEN='\033[0;32m'
NC='\033[0m' # No Color

rget='wget -P -N -c --random-wait --retry-connrefused --waitretry=1 --tries=99 -O'

rclone_load() {
  local kind=$1
  local name=$2
  echo -e "\n${GREEN}$name${NC}\n"
  local bucket=$RCLONE_BAK/$kind.$name
  local json=$(rclone lsjson $bucket | jq -r ".[-1]")
  local bak=$(echo $json | jq -r ".Name")
  local tmp=/tmp/$(echo $bucket | tr -d ':')
  local fp=$tmp/$bak
  echo "→ $fp"

  bucket_bak=$bucket/$bak

  local url=https://$CDN/$kind.$name/$bak
  if [[ $(echo $json | jq -r '.IsDir') == "true" ]]; then
    mkdir -p $fp
    for name in $(rclone lsjson $bucket_bak | jq -r '.[].Path'); do
      $rget $fp/$name $url/$name
    done
  else
    mkdir -p $tmp
    $rget $fp $url
  fi

  $3 $fp $name # load
  #rm -rf $(dirname $fp)
}
