#!/usr/bin/env bash

# GIF 无损压缩
function gif_optimize() {
  local unoptimized_files=()
  local all_input_file_size=0  # 字节数
  local all_output_file_size=0 # 字节数

  local all_input_file=() # 所有将要被优化的 GIF 文件

  echo ""

  # 1. 解析函数传入参数，并将对应 GIF 传入到 all_input_file 数组
  for input_param in "$@"; do
    # TODO: 如 $@ 长度小于 1 则退出
    if [ $(IS_DIRECTORY "$input_param") -eq 0 ]; then
      for file in "$input_param"/*.gif; do
        if [ -f "$file" ]; then
          all_input_file+=("$file")
        fi
      done
      unset file
    elif [ $(IS_FILE "$input_param") -eq 0 ]; then
      # TODO: 判断是否为 GIF
      all_input_file+=("$input_param")
    fi
  done
  unset input_param

  local all_input_file_count=${#all_input_file[@]}
  if [ "$all_input_file_count" -eq 0 ]; then
    echo '❌ 没有输入目录！'
    return 0
  fi

  echo "🕒 正在处理中，请稍候..."

  # 2. 创建临时、输出目录
  local temp_dir="$OUTPUT/__TEMP"
  local output_dir="$OUTPUT"
  if [ $(IS_DIRECTORY "$temp_dir") -eq 1 ]; then
    mkdir "$temp_dir"
  fi

  # 3. 遍历 all_input_file 数组
  for file in "${all_input_file[@]}"; do
    local temp_file_path="$temp_dir/$(basename "$file")"
    local output_file_path="$output_dir/$(basename "$file")"

    # 使用 Gifsicle 对 GIF 进行“无损压缩”，存储至临时目录
    gifsicle -O2 --colors=256 "$file" >"$temp_file_path"

    # 获取处理前后的文件字节数
    local source_file_size=$(wc "$file" | awk '{print $3}')
    local temp_file_size=$(wc "$temp_file_path" | awk '{print $3}')

    # 记录所有输入文件的字节数
    all_input_file_size=$((all_input_file_size + source_file_size))

    # echo ""
    # echo $(basename "$file")
    # echo "source_file_size: $source_file_size"

    # 比较源文件与输出文件大小，将更小的文件拷贝至输出目录
    if [ "$temp_file_size" -lt "$source_file_size" ]; then
      cp "$temp_file_path" "$output_file_path"
      all_output_file_size=$((all_output_file_size + temp_file_size))
      # echo "target_file_size: $temp_file_size"
    else
      unoptimized_files+=("$(basename "$file")")
      all_output_file_size=$((all_output_file_size + source_file_size))
      cp "$file" "$output_file_path"
      # echo "target_file_size: $source_file_size"
    fi
  done
  unset file

  # 打印未优化的文件列表
  local unoptimized_file_count=${#unoptimized_files[@]}
  if [ "$unoptimized_file_count" -gt 0 ]; then
    echo ""
    echo "❌ 以下 $unoptimized_file_count 个 GIF 经 Gifsicle 处理后，因其体积反而更大了，将输出其源文件，请知悉！"
    for unoptimized_item in "${unoptimized_files[@]}"; do
      echo "==> $unoptimized_item"
    done
    unset unoptimized_item
  fi

  # 打印优化结果
  local all_change_file_size=$((all_input_file_size - all_output_file_size))
  local all_source_file_kb=$(echo "scale=2; $all_input_file_size / 1024" | bc)
  local all_target_file_kb=$(echo "scale=2; $all_output_file_size / 1024" | bc)
  local all_change_file_kb=$(echo "scale=2; $all_change_file_size / 1024" | bc)
  local all_change_size_perc=$(echo "scale=2; $all_change_file_size / $all_input_file_size * 100" | bc)
  echo ""
  echo "✅ 所有源文件共 ${all_source_file_kb}KB，处理后共 ${all_target_file_kb}KB，节省了 ${all_change_size_perc}%（约 ${all_change_file_kb}KB）。"

  # 移除临时目录
  rm -rf "$temp_dir"
}

export gif_optimize
