#!/usr/bin/env coffee
> @w5/qdrant:Q
  path > join dirname
  zx/globals:
  @w5/uridir

RDIR = 'qdrant'
ROOT = dirname uridir import.meta
TODAY = new Date().toISOString().slice(0,10)
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
  fp = join '/mnt/data/xxai.art/qdrant/snapshots',name,snapshot_name
  zstd_name = name+'.snapshots.zstd'
  zstd_fp = join TMP, zstd_name
  await $"pv -p -t -e #{fp}".pipe $"zstd -16 -T0 -o #{zstd_fp}"
  await rm name

await $"#{ROOT}/rclone_cp.sh #{TMP}/ #{RDIR}/#{TODAY}/"
await $"#{ROOT}/rclone_rm.sh #{RDIR}"

process.exit()
