#!/usr/bin/env coffee

> @w5/uridir
  path > dirname join

export ROOT = dirname uridir(import.meta)
export BAK = join ROOT, 'bak'
export DATA = join(BAK, 'data')
export SCHEMA = join(BAK, 'schema')

