#!/usr/bin/env coffee

> postgres
  fs > mkdirSync
  fs/promises > rmdir unlink
  @w5/walk
  zx/globals:
  @w5/uridir
  path > dirname
  @w5/time/Today

ROOT = dirname dirname uridir import.meta

{GT_URI} = process.env

GT = postgres(
  'postgres://'+GT_URI
  fetch_types:false
)

TODAY = Today()
TMP = "/tmp/backup/greptime/#{TODAY}"

mkdirSync TMP,recursive:true


for await i from walk TMP
  await unlink i

IGNORE = new Set [
  'numbers'
  'scripts'
]
for {Tables:table} from await GT'show tables'.simple()
  if IGNORE.has table
    continue
  console.log table
  sql = "COPY #{table} TO '#{TMP}/#{table}.parquet' WITH (FORMAT='parquet')"
  await GT.unsafe(sql).simple()

for await i from walk TMP, (i)=>!i.endsWith '.parquet'
   await $"zstd -T0 -16 #{i} -o #{i}.zstd"
   await unlink i

await $"#{ROOT}/rclone_cp.sh #{TMP}/ greptime/#{TODAY}"

process.exit()
