#!/usr/bin/env bash

set -e

function main() {
  local print_str=""
  local output_dir="/Users/frankie/Desktop/gif-test/dist"

  for file in /Users/frankie/Desktop/gif-test/end/*.gif; do
    if [ -f "$file" ]; then
      source_file=$file
      target_file="$output_dir/$(basename "$file")"

      if [ ! -d $output_dir ]; then
        mkdir $output_dir
      fi

      # 查看图片信息
      # ffprobe $source_file

      # 图片字节数
      # echo $(wc $source_file | awk '{print $3}')

      # 效果不明显，减少 1% ~ 2%
      # gifsicle "$source_file" -o "$target_file" -O3

      # 效果较明显，减少 12% ~ 14%
      # gifsicle "$source_file" -o "$target_file" --lossy

      # 效果较明显，减少 12% ~ 20%
      # gifsicle "$source_file" -o "$target_file" -O3 --lossy # 其中 lossy 默认 20
      # gifsicle "$source_file" -o "$target_file" -O3 --lossy=100 # ，往上调参数，压缩大小有明显变化，同时质量也差得比较明显

      # 几乎无效果，只能减少 1Kb ~ 2Kb
      # gifsicle "$source_file" -o "$target_file" --no-extensions

      # 源文件帧数
      source_file_frame_num=$(gifsicle "$source_file" -I | head -n 1 | awk '{print $3}')

      # 抽去第一帧，降低 12% ~ 32%，但质量极差，猜测是原图经过压缩出来，将大部分不变的区域到放在了第一帧上面。
      # 因此不建议抽去第一帧
      # gifsicle "$source_file" -o "$target_file" --delete "#0"

      # 删除第二帧
      # gifsicle "$source_file" -o "$target_file" --delete "#1"

      # 抽去奇数帧，降低 40% ~ 50%，导致速度加快的同时，而且动画很可能不衔接，可能质量较差
      gifsicle "$source_file" $(seq -f "#%g" 0 2 "$((source_file_frame_num - 1))") >"$target_file"

      # i=0
      # cp "$source_file" "$output_dir/$(basename "$file")"
      # while [[ $i -lt $source_file_frame_num ]]; do
      #   rem=$((i % 2))
      #   if [ $rem -eq 1 ]; then
      #     gifsicle "$target_file" -o "$target_file" --delete "#$((i / 2))"
      #   fi
      #   i=$((i + 1))
      # done

      # 目标文件帧数
      # target_file_frame_num=$(gifsicle "$target_file" -I | head -n 1 | awk '{print $3}')
      # echo "befor: $source_file_frame_num"
      # echo "after: $target_file_frame_num"

      # 文件字节数
      source_size_byte=$(wc "$source_file" | awk '{print $3}')
      target_size_byte=$(wc "$target_file" | awk '{print $3}')

      source_size_kb=$(echo "scale=2; $source_size_byte / 1024" | bc)
      target_size_kb=$(echo "scale=2; $target_size_byte / 1024" | bc)

      change_size_byte=$((source_size_byte - target_size_byte))
      change_size_kb=$(echo "scale=2; $change_size_byte / 1024" | bc)
      change_size_perc=$(echo "scale=2; $change_size_byte / $source_size_byte * 100" | bc)

      print_str="$print_str\n\n
      $source_file:\n
      原图: $source_size_kb KB\n
      处理后: $target_size_kb KB\n
      减少了: $change_size_kb KB\n
      压缩比例: $change_size_perc%"
    fi
  done

  echo -e "$print_str"
}

main
