#!/usr/bin/env zx

const indexDir = '/Users/frankie/Desktop/gif-test/end'
const ouputDir = '/Users/frankie/Desktop/gif-test/dist'

// 按目录以及扩展名查找文件
function findFiles({ dir, ext, recursive = true }) {
  return fs
    .readdirSync(dir)
    .map(basename => path.resolve(dir, basename))
    .reduce((arr, item) => {
      const extension = path.extname(item)
      const stat = fs.lstatSync(item)
      if (stat.isFile() && extension === ext) {
        arr.push(item)
      } else if (recursive && stat.isDirectory()) {
        arr = arr.concat(findFiles({ dir: item, ext, recursive }))
      }
      return arr
    }, [])
}

// 获取文件总帧数
async function getAllFrameNum(file) {
  return $`gifsicle ${file} -I | head -n 1 | awk '{print $3}'`
}

// 获取帧数偶数项，返回如 ['#0', '#2', '#n', ...]
function getEvenByRange(range) {
  const arr = Array.from({ length: range }, (_, i) => i)
  const evenArr = arr.filter(i => i % 2 === 0)
  return evenArr.map(i => `#${i}`)
}

// 按比例获取随机帧，返回如 ['#0', '#2', '#n', ...]
function getRandomFrames(range, perc = 0.1) {
  const arr = Array.from({ length: range }, (_, i) => i)
  let count = arr.length * perc // 抽取数量

  if (count < 1) count = 1
  count = Math.floor(count)
  console.log(`在 ${range} 帧中随机抽去其中 ${count} 帧`)

  let i = arr.length
  while ((i--, count--)) {
    const j = Math.floor(Math.random() * i)
    arr.splice(j, 1)
  }

  // 确保第一帧不被抽去
  if (!arr.includes(0)) {
    count += 1
    arr.unshift(0)
  }

  return arr.map(item => `#${item}`)
}

async function main() {
  const ext = '.gif'

  if (!fs.existsSync(indexDir)) {
    console.log(`--> error: 目录不存在 ${indexDir}`)
    $`exit 1`
  }

  const files = findFiles({ dir: indexDir, ext, recursive: false })

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

    // 效果不明显，减少 1% ~ 3%
    // await $`gifsicle ${sourceFile} -o ${targetFile} -O2`
    await $`gifsicle ${sourceFile} -o ${targetFile} -O3`

    // 效果明显，减少 12% ~ 14%
    // await $`gifsicle ${sourceFile} -o ${targetFile} --lossy`

    // 效果明显，减少 12% ~ 18%
    // await $`gifsicle ${sourceFile} -o ${targetFile} -O3 --lossy`

    // 效果明显，减少 20% ~ 30%，同时质量降低也较为明显
    // await $`gifsicle ${sourceFile} -o ${targetFile} -O3 --lossy=100`

    // 抽去奇数帧
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
