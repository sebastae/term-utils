#!/usr/bin/env bash

# gco - git checkout with fuzzy find
# Usage: gco [query]
#
# If only a single branch matches the query, skip selection
unalias gco >/dev/null 2>&1
function gco() {
  if [ ! $(git rev-parse --is-inside-work-tree) ]; then
    return 1
  fi

  if [ -n $1 ]; then
    if [ $(git branch -q | cut --complement -b1,2 | grep "^$1\$") ]; then
      git checkout $1
      return 0
    fi
  fi

  BRANCH=$(
    {git branch -q | sed -r 's/^.{2}//'
    git branch -rq | sed 's/^\s*\w*\///;/^HEAD/d'} | sort -u | fzf --preview "" --query "$1" -1
  )
  if [ -z $BRANCH ]; then
    return 0
  fi

  git checkout $BRANCH
}

# update-nvim - Download the latest nvim release and install it to /opt/nvim-linux-x86_64/
function update-nvim() {
  local url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
  curl -LO --output-dir /tmp "$url"
  local dl_result="$?"

  [ "$dl_result" -ne 0 ] && return $(
    echo "Failed to download tarball: exit code $dl_result" >&2
    false
  )

  local tarball="/tmp/$(basename "$url")"
  [ ! -f "$tarball" ] && return $(
    echo "Downloaded tarball not found ($tarball)" &>2
    0
  )

  if [ -d /opt/nvim-linux-x86_64 ]; then
    sudo rm -rf /opt/nvim-linux-x86_64 || return $(
      echo "Could not remove old directory (/opt/nvim-linux-x86_64)"
      >&2
      false
    )
  fi

  sudo tar -C /opt -xzf "$tarball" || return $(
    echo "Could not extract tarball: exit code $?" >&2
    false
  )
  echo "Updated nvim"
}
