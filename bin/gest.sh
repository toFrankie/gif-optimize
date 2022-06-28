#!/usr/bin/env bash

set -e

function main() {
  local print_str=""
  local output_dir="/Users/frankie/Desktop/gif-test/dist"
  # index_dir="$PWD/*.gif"

  for file in /Users/frankie/Desktop/gif-test/end/*.gif; do
    if [ -f "$file" ]; then
      source_file=$file
      target_file="$output_dir/$(basename "$file")"

      if [ ! -d $output_dir ]; then
        mkdir $output_dir
      fi

      # 查看图片信息
      # ffmpeg -i $file

      # 图片字节数
      # echo $(wc $file | awk '{print $3}')

      # 效果不明显，1% ~ 2%
      # gifsicle "$source_file" -o "$target_file" -O3

      # 效果较明显，有 12% ~ 20%
      gifsicle "$source_file" -o "$target_file" -O3 --lossy

      source_size_byte=$(wc "$source_file" | awk '{print $3}')
      target_size_byte=$(wc "$target_file" | awk '{print $3}')

      source_size_kb=$(echo "scale=2; $source_size_byte / 1024" | bc)
      target_size_kb=$(echo "scale=2; $target_size_byte / 1024" | bc)

      change_size_byte=$((source_size_byte - target_size_byte))
      change_size_kb=$(echo "scale=2; $change_size_byte / 1024" | bc)
      change_size_per=$(echo "scale=2; $change_size_byte / $source_size_byte * 100" | bc)

      print_str="$print_str\n\n
      $source_file:\n
      原图: $source_size_kb KB\n
      修改: $target_size_kb KB\n
      变化: $change_size_kb KB\n
      变化百分比: $change_size_per%"
    fi
  done

  echo -e "$print_str"
}

main
