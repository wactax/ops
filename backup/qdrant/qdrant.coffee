#!/usr/bin/env coffee
> @w5/pg/PG > ITER ONE
  @w5/qdrant:Q
  @w5/sleep


{clip} = Q.POST.collections
{points} = clip
points_payload = points.payload

limit = 32
iter = ITER.bot.task('rid',{where:"iaa>25", limit})


+ li, id_rid, n

init = =>
  li = []
  id_rid = new Map
  n = 0
  return

fix = (id, rid, payload) =>
  rid = id_rid.get(id)
  [w,h] = await ONE"SELECT w,h FROM bot.civitai_img WHERE id=#{rid}"
  if payload.w != w or payload.h != h
    console.log id,w,h,payload
    payload.w = w
    payload.h = h
    await points_payload {
      payload
      points: [id]
    }
    await sleep(3000)
  return

init()

for await [id, rid] from iter
  id_rid.set id, rid
  li.push id
  if ++n == limit
    console.log li
    runing = []
    for o from await points {
      ids:li
      with_payload: true
    }
      {id,payload} = o
      runing.push fix id,id_rid.get(id),payload
    await Promise.all runing

    init()
process.exit()
