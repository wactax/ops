#!/usr/bin/env bash
set -e

src=$HOME
bak=/mnt/btfs.snapshot$src
if [ ! -d "$bak" ]; then
  mkdir -p $bak
fi
fp=$bak/$(date "+%Y-%m-%d_%H.%M.%S")
btrfs subvolume snapshot -r $src $fp

KEEP_COUNT=30

cd "$bak"

# 获取所有的子卷文件名，按名称排序
subvolumes=($(ls -1 | sort))

# 获取需要删除的子卷数量
delete_count=$((${#subvolumes[@]} - KEEP_COUNT))

# 如果需要删除的子卷数量小于0，说明总子卷数量不足保留数量
if ((delete_count <= 0)); then
  echo "总子卷数量小于或等于 $KEEP_COUNT 个。没有要删除的子卷。"
  exit 0
fi

# 循环删除多余的子卷
for ((i = 0; i < $delete_count; i++)); do
  echo "正在删除子卷: ${subvolumes[$i]}"
  sudo btrfs subvolume delete "${DIR}${subvolumes[$i]}"
done
