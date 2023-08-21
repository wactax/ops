#!/usr/bin/env coffee

> zx/globals:
  @w5/uridir
  path > basename

{ PG_URI } = process.env

if not ( PG_URI and PG_URI.endsWith '-dev' )
  console.log "数据库名称不包含 -dev 不执行，小心误操作"
  process.exit()

< default main = =>
  ROOT = uridir(import.meta)
  cd "#{ROOT}/dump/art-ol/art-ol/drop"

  {
    stdout:sql_li
  } = await $"ls *.sql"
  psql = "psql postgres://#{PG_URI}"

  sh = (cmd)=>
    $"sh -c #{cmd}"

  for sql from sql_li.trim().split '\n'
    schema = basename(sql).slice(0,-4)
    if schema != 'public'
      await sh """#{psql} -c "DROP SCHEMA #{schema} CASCADE" || true"""
    await sh "#{psql} < #{sql}"
    await sh "zstd -qcd #{ROOT}/data/art-ol/#{schema}.zstd | pg_restore --disable-triggers -d 'postgres://#{PG_URI}'"
  return

if process.argv[1] == decodeURI (new URL(import.meta.url)).pathname
  await main()
  process.exit()

