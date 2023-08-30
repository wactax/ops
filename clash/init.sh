#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

git config --global url."https://ghproxy.com/https://github.com".insteadOf "https://github.com" &&
  pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/,https://pypi.doubanio.com/simple/ &&
  export npmmirror=https://registry.npmmirror.com &&
  export GHPROXY=https://ghproxy.com/ &&
  export RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static &&
  export RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup

if [ ! -f "$HOME/.cargo/env" ]; then
  curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path --default-toolchain nightly
fi

if ! command -v cargo &>/dev/null; then
  if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
  fi
fi

to_install=""

# 检查rtx是否存在
if ! command -v rtx &>/dev/null; then
  to_install+="rtx-cli "
fi

# 检查fd是否存在
if ! command -v fd &>/dev/null; then
  to_install+="fd-find "
fi

if [ -n "$to_install" ]; then
  cargo install $to_install
fi

if ! command -v rtx &>/dev/null; then
  eval $(rtx env)
fi

if ! [ -x "$(command -v clash)" ]; then
  if ! command -v go &>/dev/null; then
    command -v rtx &>/dev/null && eval $(rtx env)
  fi
  if ! command -v go &>/dev/null; then
    rtx install go
    rtx list | awk '{print $1 " " $2}' >~/.tool-versions
    eval $(rtx env)
  fi
  if ! [ -x "$(command -v clash)" ]; then
    go env -w GOPROXY=https://mirrors.aliyun.com/goproxy/,direct
    go install github.com/Dreamacro/clash@latest
  fi
fi
