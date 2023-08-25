#!/usr/bin/env bash
set -ex
rdir=$RCLONE_BAK/$1
rclone lsjson $rdir | jq -r ".[].Name" | sort | head -n -3 |
  xargs -I {} rclone delete $rdir/{}
