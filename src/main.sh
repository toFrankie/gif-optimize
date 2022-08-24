#!/usr/bin/env bash

# set -u

# 导出主目录
MAIN_DIR="$(dirname $(readlink -f $0))"
export MAIN_DIR

# 添加模块目录至 PATH
FILE_MODULE="$MAIN_DIR/modules"
if [[ ! $PATH =~ $FILE_MODULE ]]; then
  export PATH=$PATH:$FILE_MODULE
fi

# 加载对应模块
source file.sh

echo "入口参数：$*"

# 读取参数，https://cloud.tencent.com/developer/article/1815341
# 包括 -o、-d、-i 三个参数，除去 -o、-d 之外，其他均视为 input 参数。
INPUT=()
while [[ $# -gt 0 ]]; do
  key="$1"

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

# set -- "${INPUT[@]}" # restore positional parameters

# echo FILE OUTPUT = "${OUTPUT}"
# echo FILE FRAME_DRAW = "${FRAME_DRAW}"
# echo FILE ALL = "${INPUT[*]}"
# echo FILE 'ALL[1]' = "${INPUT[1]}"

# 判断参数
INPUT_FILES=()
INPUT_DIRS=()

for item in "${INPUT[@]}"; do
  echo ''
  if [ $(IS_FILE "$item") -eq 0 ]; then
    INPUT_FILES+=("$item")
  elif [ $(IS_DIRECTORY "$item") -eq 0 ]; then
    INPUT_DIRS+=("$item")
  else
    echo "未知文件：$item"
  fi
done

echo "最终目录：${INPUT_DIRS[*]}"
echo "最终文件：${INPUT_FILES[*]}"

# 检查参数
# 1. INPUT 需为目录或文件，如缺省取当前目录；
# 2. OUTPUT 需为目录；
# 3. FRAME_DRAW 范围需在 0 ~ 100；
