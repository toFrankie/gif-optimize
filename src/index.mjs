#!/usr/bin/env zx

$.verbose = false

import { findFiles } from './utils/file.mjs'
import { getAllFrameNum, getEvenByRange, getRandomFrames } from './utils/gif.mjs'

const inputDir = (await $`echo $HOME/Desktop/gif-test/input`).stdout.trim()
const ouputDir = (await $`echo $HOME/Desktop/gif-test/dist`).stdout.trim()

async function main() {
  const ext = '.gif'

  if (!fs.existsSync(inputDir)) {
    console.log(`--> error: 目录不存在 ${inputDir}`)
    $`exit 1`
  }

  const files = findFiles({ dir: inputDir, ext, recursive: false })

  if (files.length && !fs.existsSync(ouputDir)) {
    await $`mkdir ${ouputDir}`
  }

  let printStr = '\n\n'
  for (const sourceFile of files) {
    const filename = path.basename(sourceFile, ext)
    const targetFile = path.resolve(ouputDir, filename) + ext
    const { stdout: sourceFileFrameNum } = await getAllFrameNum(sourceFile)

    // 图片信息信息
    // await $`ffprobe ${sourceFile}`

    // 一些测试用例：

    // 效果不明显，减少 1% ~ 3%
    // await $`gifsicle ${sourceFile} -o ${targetFile} -O2`
    await $`gifsicle ${sourceFile} -o ${targetFile} -O3`

    // 效果明显，减少 12% ~ 14%
    // await $`gifsicle ${sourceFile} -o ${targetFile} --lossy`

    // 效果明显，减少 12% ~ 18%
    // await $`gifsicle ${sourceFile} -o ${targetFile} -O3 --lossy`

    // 效果明显，减少 20% ~ 30%，同时质量降低也较为明显
    // await $`gifsicle ${sourceFile} -o ${targetFile} -O3 --lossy=100`

    // 抽去奇数帧，输出质量不好
    // const evenFrames = getEvenByRange(sourceFileFrameNum)
    // await $`gifsicle ${sourceFile} ${evenFrames} > ${targetFile}`

    // 按比例抽去随机帧（去掉第一帧），具体大小视乎抽取比例，输出质量不好说。以抽掉 10% 为例，降低了 8% ~ 30% 不等。
    // const randomFrames = getRandomFrames(sourceFileFrameNum, 0.1)
    // await $`gifsicle ${sourceFile} ${randomFrames} > ${targetFile}` // 减少 4% ~ 6%
    // await $`gifsicle ${sourceFile} -O3 ${randomFrames} > ${targetFile}` // 减少 4% ~ 12%

    // before
    const { stdout: sourceSizeByte } = await $`wc ${sourceFile} | awk '{print $3}'`
    const { stdout: targetSizeByte } = await $`wc ${targetFile} | awk '{print $3}'`
    const sourceSizeKb = sourceSizeByte / 1024
    const targetSizeKb = targetSizeByte / 1024

    // after
    const changeSizeByte = sourceSizeByte - targetSizeByte
    const changeSizeKb = (sourceSizeByte - targetSizeByte) / 1024
    const changeSizePerc = (changeSizeByte / sourceSizeByte) * 100

    printStr = `${printStr}
${sourceFile}
  原图：${sourceSizeKb.toFixed(2)} KB
  处理后：${targetSizeKb.toFixed(2)} KB
  减少了：${changeSizeKb.toFixed(2)} KB
  压缩比例：${changeSizePerc.toFixed(2)}%\n`
  }

  console.log(printStr)
  console.log(`🎉🎉🎉 Done.\n`)
}

main()
