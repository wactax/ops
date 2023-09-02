#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR

set -e

case $(uname -s) in
Linux*)
  echo "为避免误操作，不在 Linux 上运行"
  exit 0
  ;;
esac

source ../rclone_load.sh

#nc -z -w 1 127.0.0.1 7890 && export https_proxy=http://127.0.0.1:7890

trim() {
  echo $1 | sed 's/\.[^\.]*$//'
}

load() {
  dir=$1
  day=$(basename $dir)
  for i in "$(ls $dir)"; do
    name=$(trim $(trim $i))
    echo $name
    outdir=$DIR/snapshots/$name
    mkdir -p $outdir
    ofp=$outdir/$day.snapshot
    pv $dir/$i | zstd -d -c >$ofp
    echo "→ 导入 ${name}"
    curl --progress-bar -X POST \
      "$QDRANT_HTTP/collections/$name/snapshots/upload" \
      -H 'Content-Type:multipart/form-data' \
      -H "api-key:$QDRANT__SERVICE__API_KEY" \
      -F "snapshot=@$ofp"
    rm -rf $ofp
  done
}

rclone_load qdrant
