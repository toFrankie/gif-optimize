#!/usr/bin/env bash

# set -u

# 导出主目录
MAIN_DIR="$(dirname $(readlink -f $0))"
START_DIR=$PWD
export MAIN_DIR
export START_DIR

# 添加模块目录至 PATH
FILE_MODULE="$MAIN_DIR/modules"
if [[ ! $PATH =~ $FILE_MODULE ]]; then
  export PATH=$PATH:$FILE_MODULE
fi

# 加载对应模块（@TODO: 模块名再修改下）
source file.sh
source param.sh
source optimize.sh

# echo "入口参数：$*"

# 解析参数
get_cli_param "$@"

# 解析输入
parse_input "${INPUT[@]}"

# 创建输出目录
if [ -z "$OUTPUT" ]; then
  OUTPUT=$START_DIR
elif [ $(IS_DIRECTORY "$OUTPUT") -eq 1 ]; then
  mkdir "$OUTPUT"
fi

# 执行优化
gif_optimize "${INPUT[@]}"
echo ""

# echo ""
# echo FILE INPUT = "${INPUT[*]}"
# echo FILE OUTPUT = "${OUTPUT}"
# echo FILE FRAME_DRAW = "${FRAME_DRAW}"

# 检查参数
# 1. INPUT 需为目录或文件，如缺省取当前目录；
# 2. OUTPUT 需为目录；
# 3. FRAME_DRAW 范围需在 0 ~ 100；
