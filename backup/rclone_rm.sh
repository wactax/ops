#!/usr/bin/env bash

rdir=$RCLONE_BAK/$2
rclone lsjson $rdir | jq -r ".[].Name" | sort | head -n -3 |
  xargs -I {} rclone delete $rdir/{}
