export function FileInfo(base: Partial<Deno.FileInfo>): Deno.FileInfo {
  return {
    isFile: true,
    isDirectory: true,
    isSymlink: true,
    size: 10,
    mtime: new Date(),
    atime: new Date(),
    birthtime: new Date(),
    dev: 9,
    ino: 8,
    mode: 7,
    nlink: 6,
    uid: 5,
    gid: 4,
    rdev: 1,
    blksize: 3,
    blocks: 2,
    ...base,
  };
}
