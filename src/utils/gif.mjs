/**
 * 获取文件总帧数
 * @param {string} file 文件路径
 * @returns 帧数
 */
export const getAllFrameNum = async file => {
  return $`gifsicle ${file} -I | head -n 1 | awk '{print $3}'`
}

/**
 * 获取帧数偶数项
 * @param {number} range 帧数
 * @returns 返回如 ['#0', '#2', '#n', ...]
 */
export const getEvenByRange = range => {
  const arr = Array.from({ length: range }, (_, i) => i)
  const evenArr = arr.filter(i => i % 2 === 0)
  return evenArr.map(i => `#${i}`)
}

/**
 * 按比例获取随机帧
 * @param {number} range 帧数
 * @param {number} perc 百分比
 * @returns 返回如 ['#0', '#2', '#n', ...]
 */
export const getRandomFrames = (range, perc = 0.1) => {
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
