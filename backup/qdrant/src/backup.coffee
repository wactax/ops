#!/usr/bin/env coffee
> @w5/qdrant:Q
  path > join dirname
  zx/globals:
  @w5/uridir
  @w5/time/Today

RDIR = 'qdrant'
ROOT = dirname dirname uridir import.meta
TODAY = Today()
TMP = '/tmp/qdrant.bak'

await $"rm -rf #{TMP}"

TMP = join TMP, TODAY

await $"mkdir -p #{TMP}"

{collections} = await Q.GET.collections()

rm = (name)=>
  for {name:snapshot_name} from await Q.GET.collections[name].snapshots()
    await Q.DELETE.collections[name].snapshots[snapshot_name]()
  return

for {name} from collections
  {name:snapshot_name} = await Q.POST.collections[name].snapshots()

  zstd_name = name+'.snapshots.zstd'
  zstd_fp = join TMP, zstd_name

  fp = join '/mnt/data/xxai.art/qdrant/snapshots',name,snapshot_name

  await $"zstd -16 -T0 -o #{zstd_fp} #{fp}"

  await rm name

await $"#{ROOT}/rclone_cp.sh #{TMP}/ #{RDIR}/#{TODAY}/"
await $"#{ROOT}/rclone_rm.sh #{RDIR}"

process.exit()
