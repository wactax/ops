#!/usr/bin/env coffee
> @w5/qdrant:Q
  path > join dirname
  zx/globals:
  @w5/uridir

ROOT = dirname uridir import.meta

#{name} = await Q.POST.snapshots()
name = 'full-snapshot-2023-09-02-04-54-51.snapshot'
fp = join '/mnt/data/xxai.art/qdrant/snapshots',name

tmp = '/tmp/qdrant'

await $"mkdir -p #{tmp}"
ofp = join tmp,name+'.zstd'
await $"rm -rf #{ofp}"
await $"zstd -16 -T0 -o #{ofp} #{fp}"
await Q.DELETE.snapshots[name]()
rdir = 'qdrant'
await $"#{ROOT}/rclone_cp.sh #{ofp} #{rdir}/"
await $"#{ROOT}/rclone_rm.sh #{rdir}"

process.exit()
