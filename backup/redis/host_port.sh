#!/usr/bin/env bash

host_port() {
  if [[ $$1 =~ \[(([0-9a-fA-F:]+))\]:([0-9]+)$ ]]; then
    # IPv6
    ip="${BASH_REMATCH[2]}"
    port="${BASH_REMATCH[3]}"
  elif [[ $$1 =~ ([0-9\.]+):([0-9]+)$ ]]; then
    # IPv4
    ip="${BASH_REMATCH[1]}"
    port="${BASH_REMATCH[2]}"
  else
    echo "$$1 Invalid Ip Format"
    exit 1
  fi
}
