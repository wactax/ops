#!/usr/bin/env -S node --loader=@w5/jsext --trace-uncaught --expose-gc --unhandled-rejections=strict
var ROOT, fp, name, ofp, rdir, ref, snapshots_rm, tmp, x;

import Q from '@w5/qdrant';

import {
  join,
  dirname
} from 'path';

import 'zx/globals';

import uridir from '@w5/uridir';

({
  snapshots: snapshots_rm
} = Q.DELETE);

ROOT = dirname(uridir(import.meta));

({name} = (await Q.POST.snapshots()));

fp = join('/mnt/data/xxai.art/qdrant/snapshots', name);

tmp = '/tmp/qdrant';

await $`mkdir -p ${tmp}`;

ofp = join(tmp, name + '.zstd');

await $`rm -rf ${ofp}`;

await $`zstd -16 -T0 -o ${ofp} ${fp}`;

ref = (await Q.GET.snapshots());
for (x of ref) {
  ({name} = x);
  await snapshots_rm[name]();
}

rdir = 'qdrant';

await $`${ROOT}/rclone_cp.sh ${ofp} ${rdir}/`;

await $`${ROOT}/rclone_rm.sh ${rdir}`;

process.exit();
