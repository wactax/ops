#!/usr/bin/env coffee
> @w5/qdrant:Q
  path > join dirname
  zx/globals:
  @w5/uridir

ROOT = dirname uridir import.meta

{name} = await Q.POST.snapshots()

fp = join '/mnt/data/xxai.art/qdrant/snapshots',name

tmp = '/tmp/qdrant'

await $"mkdir -p #{tmp}"
ofp = join tmp,name+'.zstd'
await $"pv #{fp} | zstd -19 > #{ofp}"
await Q.DELETE.snapshots[name]()
await $"#{ROOT}/rclone_cp.sh #{ofp} qdrant/"

process.exit()
