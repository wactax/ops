#!/usr/bin/env coffee

> postgres
  fs > mkdirSync
  fs/promises > rmdir
  @w5/walk

{GT_URI} = process.env

GT = postgres(
  'postgres://'+GT_URI
  fetch_types:false
)

BACKUP_DIR = '/tmp/backup/greptime'

mkdirSync BACKUP_DIR,recursive:true

for await i from walk BACKUP_DIR
  await rmdir i

for {Tables:table} from await GT'show tables'.simple()
  console.log table
  await GT"COPY #{table} TO '#{BACKUP_DIR}/#{table}.parquet' WITH (FORMAT='parquet')".simple()


process.exit()
