#!/usr/bin/env coffee

> @w5/qdrant:Q

[
  name
] = process.argv.slice(2)

console.log '!',{name}
