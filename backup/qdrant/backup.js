#!/usr/bin/env -S node --loader=@w5/jsext --trace-uncaught --expose-gc --unhandled-rejections=strict
var RDIR, TMP, TODAY, collections, fp, name, rm, snapshot_name, x, zstd_fp, zstd_name;

import Q from '@w5/qdrant';

import {
  join,
  dirname
} from 'path';

import 'zx/globals';

import uridir from '@w5/uridir';

({collections} = (await Q.GET.collections()));

rm = async(name) => {
  var ref, snapshot_name, x;
  ref = (await Q.GET.collections[name].snapshots());
  for (x of ref) {
    ({
      name: snapshot_name
    } = x);
    await Q.DELETE.collections[name].snapshots[snapshot_name]();
  }
};

TODAY = new Date().toISOString().slice(0, 10);

TMP = '/tmp/qdrant.bak';

await $`rm -rf ${TMP}`;

await $`mkdir -p ${TMP}`;

RDIR = 'qdrant';

for (x of collections) {
  ({name} = x);
  ({
    name: snapshot_name
  } = (await Q.POST.collections[name].snapshots()));
  fp = join('/mnt/data/xxai.art/qdrant/snapshots', name, snapshot_name);
  zstd_name = name + '.snapshots.zstd';
  zstd_fp = join(TMP, zstd_name);
  await $`pv ${fp} | zstd -16 -T0 -o ${zstd_fp}`;
  await rm(name);
}

await $`${ROOT}/rclone_cp.sh ${TMP} ${RDIR}/${TODAY}/`;

await $`${ROOT}/rclone_rm.sh ${RDIR}`;

process.exit();
