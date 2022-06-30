# 说明

测试脚本存放于 `src/bin/gest.mjs`，基于 [zx](https://github.com/google/zx) 编写。

## 快速开始

```shell
# 安装相关图片处理工具
$ brew install ffmpeg gifsicle
```

```shell
# 拉取代码
$ git clone https://github.com/toFrankie/simple-shell.git

# 全局安装此包
$ npm i -g <path/to/project>

# 全局安装 zx
$ npm i -g zx

# 然后就可以全局使用 `gest` 命令了，即执行执行测试脚本
$ gest
```

目前脚本不是很「智能」，需要跟进实际去调整脚本中的 `indexDir`、`outputDir` 路径。执行脚本会对 `indexDir` 目录下 gif 执行对应的操作，然后输出到 `outputDir` 目录中。处理结果会在命令行中打印出来。
