import { DotEntry } from "./types.ts";
import { basename, join, relative, resolve } from "./deps.ts";
import THIS, { DOT_LOCATION, REPO_LOCATION } from "./env.ts";

const dotfileNameFromTarget = (file: string) =>
  "." +
  Object.entries(THIS).reduce(
    (value, [label, search]) => value.replace("_" + search, "_" + label),
    file
  );

const invalidPattern = new RegExp(`^_(?!${Object.values(THIS).join("|")})`);
export const isInvalidFileToTarget = (file: string) => {
  return invalidPattern.test(basename(file));
};

export const exists = async (filePath: string): Promise<boolean> => {
  try {
    await Deno.lstat(filePath);
    return true;
  } catch (err) {
    if (err instanceof Deno.errors.NotFound) {
      return false;
    }
    throw err;
  }
};

export const directoryIsEmpty = async (dirPath: string): Promise<boolean> => {
  for await (const _ of Deno.readDir(dirPath)) {
    return false;
  }
  return true;
};

export const absoluteDotfile = (subPath?: string) => {
  if (subPath) return join(DOT_LOCATION, subPath);
  return DOT_LOCATION;
};

export const relativeDotfile = (file: string) =>
  file.startsWith("/")
    ? relative(absoluteDotfile(), file)
    : dotfileNameFromTarget(file);

export const identical = (
  first: Deno.FileInfo,
  second: Deno.FileInfo
): boolean => first.ino === second.ino && first.dev === second.dev;

export async function* getDotFiles(
  dir: string,
  options: {
    nameRelativeToBase?: boolean;
    baseToOmit?: string;
    recurse?: boolean;
  }
): AsyncGenerator<[string, string]> {
  if (options.nameRelativeToBase) {
    options.baseToOmit = dir;
    delete options.nameRelativeToBase;
  }

  for await (const entry of Deno.readDir(dir)) {
    const relativeTarget = join(dir, entry.name);

    if (options.recurse && entry.isDirectory) {
      yield* getDotFiles(relativeTarget, options);
    } else {
      yield [
        absoluteDotfile(
          dotfileNameFromTarget(
            options.baseToOmit
              ? relative(options.baseToOmit, relativeTarget)
              : relativeTarget
          )
        ),
        resolve(relativeTarget),
      ];
    }
  }
}

export async function* findDotLinks(
  dir: string,
  options: {
    recursive?: boolean;
    filter?: (arg: Deno.DirEntry) => boolean;
  } = {}
): AsyncGenerator<DotEntry> {
  for await (const item of Deno.readDir(dir)) {
    const path = join(dir, item.name);
    if (options.recursive && item.isDirectory) {
      yield* findDotLinks(path, options);
    } else if (item.isSymlink) {
      const target = await Deno.readLink(path);
      if (
        target.startsWith(REPO_LOCATION) &&
        (!options.filter || options.filter(item))
      ) {
        yield {
          name: item.name,
          path,
          target,
        };
      }
    }
  }
}
