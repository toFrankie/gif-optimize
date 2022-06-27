#!/bin/bash

# file=example.gif
# echo "${file%.*}" # 输出 ./example
# echo "${file#*.}" # 输出 /A.gif
# echo "${file##*.}" # 输出 gif
# echo $file # 输出 ./A.gif
# echo $(basename "$file") # 输出 A.gif

# 命令行参数
# $0 执行脚本名称
# $2 第二个参数

# byte_number=`wc xxx.dat | awk '{print $3}'` # 字节数

# -e 判断对象是否存在
# -d 判断对象是否存在，并且为目录
# -f 判断对象是否存在，并且为常规文件
# -L 判断对象是否存在，并且为符号链接
# -h 判断对象是否存在，并且为软链接
# -s 判断对象是否存在，并且长度不为0
# -r 判断对象是否存在，并且可读
# -w 判断对象是否存在，并且可写
# -x 判断对象是否存在，并且可执行
# -O 判断对象是否存在，并且属于当前用户
# -G 判断对象是否存在，并且属于当前用户组
# -nt 判断file1是否比file2新  [ "/data/file1" -nt "/data/file2" ]
# -ot 判断file1是否比file2旧  [ "/data/file1" -ot "/data/file2" ]

printStr=""
outputDir="/Users/frankie/Desktop/gif-test/dist"
# indexDir="$PWD/*.gif"

for file in /Users/frankie/Desktop/gif-test/end/*.gif; do
  if [ -f $file ]; then
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
    # gifsicle $source_file -o $target_file -O3

    # 效果较明显，有 12% ~ 13%
    gifsicle $source_file -o $target_file -O3 --lossy

    source_size_byte=$(wc $source_file | awk '{print $3}')
    target_size_byte=$(wc $target_file | awk '{print $3}')

    source_size_kb=$(echo "scale=4; $source_size_byte / 1024" | bc)
    target_size_kb=$(echo "scale=4; $target_size_byte / 1024" | bc)

    change_size_byte=$(($source_size_byte - $target_size_byte))
    change_size_kb=$(echo "scale=4; $change_size_byte / 1024" | bc)
    change_size_per=$(echo "scale=2; $change_size_byte / $source_size_byte * 100" | bc)

    printStr="$printStr\n\n
    $source_file:\n
    原图: $source_size_kb KB\n
    修改: $target_size_kb KB\n
    变化: $change_size_kb KB\n
    变化百分比: $change_size_per%"
  fi
done

echo -e $printStr
