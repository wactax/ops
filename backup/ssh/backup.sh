#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

if [ ! -d "ssh" ]; then
  git clone --depth=1 git@github.com:ol-conf/ssh.git
fi

cd ssh
source host.sh

host_sync() {
  mkdir -p $1/root/.config
  rsync --perms -avz --progress $1:/root/.ssh $1/root
  rsync -avz --progress $1:/root/.gitconfig $1/root
  rsync -avz --progress $1:/root/.config/git $1/root/.config || true
}

for host in $HOST_LI; do
  host_sync $host &
done

wait

git pull
git add .
git commit -m.
git push
