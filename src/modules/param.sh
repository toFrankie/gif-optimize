#!/usr/bin/env bash

# 读取参数，https://cloud.tencent.com/developer/article/1815341
# 包括 -o、-d、-i 三个参数，除去 -o、-d 之外，其他均视为 input 参数。
function get_cli_param() {
  INPUT=()
  OUTPUT=''
  FRAME_DRAW=''

  while [[ $# -gt 0 ]]; do
    local key="$1"

    case $key in
    -o | --output)
      OUTPUT="$2"
      shift # past argument
      shift # past value
      ;;
    -d | --frame-draw)
      FRAME_DRAW="$2"
      shift # past argument
      shift # past value
      ;;
    *)
      INPUT+=("$1") # save it in an array for later
      shift         # past argument
      ;;
    esac
  done

  if [ $(IS_DIRECTORY "$OUTPUT") -eq 1 ]; then
    OUTPUT=$START_DIR
  fi

  set -- "${INPUT[@]}" # restore positional parameters
}

# 判断参数
function parse_input() {
  INPUT_FILES=()
  INPUT_DIRS=()

  for item in "$@"; do
    if [ $(IS_FILE "$item") -eq 0 ]; then
      INPUT_FILES+=("$item")
    elif [ $(IS_DIRECTORY "$item") -eq 0 ]; then
      INPUT_DIRS+=("$item")
    else
      echo "未知文件：$item"
    fi
  done

  unset item
}

export get_cli_param
export parse_input
