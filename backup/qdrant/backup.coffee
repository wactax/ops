#!/usr/bin/env coffee
> @w5/qdrant:Q
  path > join dirname
  zx/globals:
  @w5/uridir


{collections} = await Q.GET.collections()

rm = (name)=>

  return

for {name} from collections
  await Q.POST.collections[name].snapshots()
  # for {name:snapshot_name} from await Q.GET.collections[name].snapshots()
  #   await Q.DELETE.collections[name].snapshots[snapshot_name]()
# {snapshots:snapshots_rm} = Q.DELETE

# ROOT = dirname uridir import.meta
# {name} = await Q.POST.snapshots()
# fp = join '/mnt/data/xxai.art/qdrant/snapshots',name
#
# tmp = '/tmp/qdrant'
#
# await $"mkdir -p #{tmp}"
# ofp = join tmp,name+'.zstd'
#
# await $"rm -rf #{ofp}"
# await $"zstd -16 -T0 -o #{ofp} #{fp}"
#
# for {name} from await Q.GET.snapshots()
#   await snapshots_rm[name]()
#
# rdir = 'qdrant.clip'
#
# await $"#{ROOT}/rclone_cp.sh #{ofp} #{rdir}/"
# await $"#{ROOT}/rclone_rm.sh #{rdir}"

process.exit()
