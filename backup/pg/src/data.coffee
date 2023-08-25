#!/usr/bin/env coffee

> ./dir > DATA ROOT
  path > join basename

dump = (fp, uri, schema)=>
  await $"pg_dump #{uri} --data-only -n #{schema} -Fc -Z0 | zstd > #{fp}"
  return

RCLONE_CP = join ROOT,'rclone_cp.sh'

< (db, q, uri)=>
  dir = join DATA,db
  await $"mkdir -p #{dir}"

  for {schema_name:schema} from await q"SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT LIKE 'pg_%' AND schema_name != 'information_schema'"
    fp = "#{dir}/#{schema}.zstd"
    await dump(fp,uri,schema)
    bname = basename dir
    if not bname.includes '-dev'
      await $"#{RCLONE_CP} #{fp} pg.#{bname}"
  return

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  await main()
  process.exit()

