#!/usr/bin/env bash

function IS_FILE() {
  local file="$1"

  if [ -f "$file" ]; then
    echo 0
  else
    echo 1
  fi
}

function IS_DIRECTORY() {
  local dir="$1"

  if [ -d "$dir" ]; then
    echo 0
  else
    echo 1
  fi
}

export IS_FILE
export IS_DIRECTORY
