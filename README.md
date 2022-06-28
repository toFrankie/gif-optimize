# 说明

## Note

```shell
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
```
