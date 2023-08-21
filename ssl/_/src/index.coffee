#!/usr/bin/env coffee

> path > join
  fs > readdirSync existsSync statSync
  @w5/read
  @w5/default:

TODAY = new Date

< ACME = '/mnt/www/.acme.sh'

< fullchainFp = (name)=>
  join ACME, name, 'fullchain.cer'

sslIter = (exist)->
  for i from readdirSync ACME, withFileTypes:true
    if i.isDirectory()
      {name} = i
      if name.includes('.')
        if existsSync fullchainFp name
          yield name
  return

< hostDir = =>
  exist = new Map()
  for i from sslIter()
    if i.endsWith '_ecc'
      host = i.slice(0,-4)
    else
      host = i
    exist.set host,i
  exist

< certKey = (dir, host)=>
  key = join ACME,dir,host+'.key'
  stats = statSync(key)
  mtime = new Date(stats.mtime)

  day = (TODAY - mtime)/(86e6)
  if day >= 90
    console.error "TODO : #{dir} 证书过期了"
    return

  name = host+"_"+mtime.toISOString().slice(0,10)
  [
    name
    read fullchainFp dir
    read key
  ]

uploadSet = (upload, set, host, dir, host_li)=>
  r = certKey dir, host
  if not r
    return

  v = await upload(host, ...r)
  name = r[0]
  await Promise.all(
    host_li.map(
      (i)=>
        console.log i, '→', name
        set(i, name, v)
    )
  )
  return

< bind = (cdnLs, upload, set)=>
  host_dir = hostDir()
  domain_dir = new Map()

  add = ()=>
    if host_dir.has name
      domain_dir.default(name,=>[]).push i
      return true
    return

  for i from await cdnLs()
    if i.startsWith('.')
      name = i.slice(1)
    else
      name = i

    if not add()
      name = name.slice(name.indexOf('.')+1)
      add()

  for [name, host_li] from domain_dir.entries()
    dir = host_dir.get name
    await uploadSet(
      upload
      set
      name
      dir
      host_li
    )
  return
