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

TMP=/tmp/backup/greptime

load() {
  dir=$1
  day=$(basename $dir)
  for i in "$dir"/*.zstd; do
    parquet=${i%.zstd}
    name=$(basename $parquet)
    table=${name%.parquet}
    echo -e "\n$table"
    pv $i | zstd -d -c >$parquet
    tmp=$TMP/$name
    mv $parquet $tmp

    psql postgres://$GT_URI -c "COPY $table FROM '$tmp' WITH (FORMAT = 'parquet')"
    rm -rf $tmp
  done
}

rclone_load greptime
