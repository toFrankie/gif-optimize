#!/usr/bin/env bash

# GIF 无损压缩
function gif_optimize() {

  if [ $(IS_DIRECTORY "$INPUT") -eq 0 ]; then

    local unoptimized_files=()
    local all_source_file_size=0
    local all_target_file_size=0

    echo ""
    echo "🕒 正在处理中，请稍候..."
    for file in "$INPUT"/*.gif; do
      if [ -f "$file" ]; then
        local source_file=$file
        local temp_dir="$OUTPUT/__TEMP"
        local temp_file="$temp_dir/$(basename "$file")"
        local target_file="$OUTPUT/$(basename "$file")"

        # 创建临时目录
        if [ ! -d "$temp_dir" ]; then
          mkdir "$temp_dir"
        fi

        # 创建输出目录
        if [ ! -d "$OUTPUT" ]; then
          mkdir "$OUTPUT"
        fi

        # 使用 Gifsicle 对 GIF 进行“无损压缩”，存储至临时目录
        gifsicle -O2 --colors=256 "$source_file" >"$temp_file"

        local source_file_size=$(wc "$source_file" | awk '{print $3}')
        local temp_file_size=$(wc "$temp_file" | awk '{print $3}')

        all_source_file_size=$((all_source_file_size + source_file_size))

        # echo ""
        # echo $(basename "$file")
        # echo "source_file_size: $source_file_size"

        # 先比较源文件与输出文件大小（字节数），再拷贝文件至输出目录
        if [ "$temp_file_size" -lt "$source_file_size" ]; then
          cp "$temp_file" "$target_file"
          # echo "target_file_size: $temp_file_size"
          all_target_file_size=$((all_target_file_size + temp_file_size))
        else
          # echo "target_file_size: $source_file_size"
          # unoptimized_files+=("「$(basename "$file")」 ${source_file_size} -> ${temp_file_size}（字节数）")
          unoptimized_files+=("$(basename "$file")")
          all_target_file_size=$((all_target_file_size + source_file_size))
          cp "$source_file" "$target_file"
        fi
      fi
    done
    unset file

    local unoptimized_file_count=${#unoptimized_files[@]}
    if [ "$unoptimized_file_count" -gt 0 ]; then
      echo ""
      echo "❌ 以下 $unoptimized_file_count 个 GIF 经 Gifsicle 处理后，因其体积反而更大了，将输出其源文件，请知悉！"
      for unoptimized_item in "${unoptimized_files[@]}"; do
        echo "==> $unoptimized_item"
      done
      unset unoptimized_item
    fi

    local all_change_file_size=$((all_source_file_size - all_target_file_size))
    local all_source_file_kb=$(echo "scale=2; $all_source_file_size / 1024" | bc)
    local all_target_file_kb=$(echo "scale=2; $all_target_file_size / 1024" | bc)
    local all_change_file_kb=$(echo "scale=2; $all_change_file_size / 1024" | bc)
    local all_change_size_perc=$(echo "scale=2; $all_change_file_size / $all_source_file_size * 100" | bc)
    echo ""
    echo "✅ 所有源文件共 ${all_source_file_kb}KB，处理后共 ${all_target_file_kb}KB，节省了 ${all_change_size_perc}%（约 ${all_change_file_kb}KB）。"

    rm -rf "$temp_dir"
  fi
}
