#!/usr/bin/env coffee

> ./dir > DATA
  path > join

dump = (dir, uri, schema)=>
  await $"pg_dump #{uri} --data-only -n #{schema} -Fc -Z0 | zstd > #{dir}/#{schema}.zstd"
  return

< (db, q, uri)=>
  dir = join DATA,db

  await $"mkdir -p #{dir}"

  for {schema_name} from await q"SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT LIKE 'pg_%' AND schema_name != 'information_schema'"
    await dump(dir,uri,schema_name)

  return

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  await main()
  process.exit()

