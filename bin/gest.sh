#!/usr/bin/env bash

function main() {
  local printStr=""
  local outputDir="/Users/frankie/Desktop/gif-test/dist"
  # indexDir="$PWD/*.gif"

  for file in /Users/frankie/Desktop/gif-test/end/*.gif; do
    if [ -f "$file" ]; then
      source_file=$file
      target_file="$outputDir/$(basename "$file")"

      if [ ! -d $outputDir ]; then
        mkdir $outputDir
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

      source_size_kb=$(echo "scale=4; $source_size_byte / 1024" | bc)
      target_size_kb=$(echo "scale=4; $target_size_byte / 1024" | bc)

      change_size_byte=$((source_size_byte - target_size_byte))
      change_size_kb=$(echo "scale=4; $change_size_byte / 1024" | bc)
      change_size_per=$(echo "scale=2; $change_size_byte / $source_size_byte * 100" | bc)

      echo "$change_size_byte"

      printStr="$printStr\n\n
      $source_file:\n
      原图: $source_size_kb KB\n
      修改: $target_size_kb KB\n
      变化: $change_size_kb KB\n
      变化百分比: $change_size_per%"
    fi
  done

  echo -e "$printStr"
}

main
