#!/usr/bin/env bash

rdir=$RCLONE_BAK/$2
rclone copy $1 $rdir && rm -rf $1
