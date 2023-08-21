#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex
PG_URI=art-ol:HBOcTD8jonibw9NQ8Nbyu@127.0.0.1:9997/art-ol ./backup.sh
mkdir -p bak/data/apg-ol
mv bak/data/art-ol/bot.zstd bak/data/apg-ol/
mkdir -p bak/schema/apg-ol/table
mv bak/schema/art-ol/table/bot.sql bak/schema/apg-ol/table
mkdir -p bak/schema/apg-ol/drop
mv bak/schema/art-ol/drop/bot.sql bak/schema/apg-ol/drop
