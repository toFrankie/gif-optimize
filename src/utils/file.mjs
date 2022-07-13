/**
 * 按目录以及扩展名查找文件
 */
export const findFiles = ({ dir, ext, recursive = true }) => {
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
