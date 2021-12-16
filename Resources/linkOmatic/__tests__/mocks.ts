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

export function DirEntry(base: MockDirEntry): Deno.DirEntry {
  const withDefaults = {
    name: "someEntry",
    isFile: false,
    isDirectory: false,
    isSymlink: false,
    ...base,
  };

  if (isMockDirectory(withDefaults)) {
    const { entries, ...result } = withDefaults;
    return result;
  }

  return withDefaults;
}

type MockDirEntry = Partial<Deno.DirEntry> | MockDirectory;

interface MockDirectory extends Partial<Deno.DirEntry> {
  isDirectory: true;
  entries: MockDirEntry[];
}

export function makeMockReadDir(values: MockDirectory[]) {
  const originalReadDir = Deno.readDir;
  Deno.readDir = async function* mockReadDir(
    path: string | URL
  ): AsyncIterable<Deno.DirEntry> {
    const tree = (path as string)
      .split("/")
      .reduce((subtree: MockDirEntry[], name): MockDirEntry[] => {
        const result = subtree.find((v) => v.name === name);
        if (result) {
          if (isMockDirectory(result)) return result.entries;
          else return [result];
        }
        throw "DIR NOT FOUND";
      }, values);

    for (const entry of tree) {
      yield DirEntry(entry);
    }
  };

  return () => {
    Deno.readDir = originalReadDir;
  };
}

function isMockDirectory(value: MockDirEntry): value is MockDirectory {
  return "entries" in value;
}
