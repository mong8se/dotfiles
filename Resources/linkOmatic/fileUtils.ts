import { DotEntry } from "./types.ts";
import {
  basename,
  dirname,
  isAbsolute,
  join,
  relative,
  resolve,
} from "./deps.ts";
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

export const fullDotfilePath = (relativePath?: string) => {
  if (relativePath) return join(DOT_LOCATION, relativePath);
  return DOT_LOCATION;
};

export const relativeDotfile = (file: string) =>
  isAbsolute(file)
    ? relative(fullDotfilePath(), file)
    : dotfileNameFromTarget(file);

const resolvedDotfilePath = (
  relativeTarget: string,
  relativeToBase?: boolean
) =>
  fullDotfilePath(
    dotfileNameFromTarget(
      relativeToBase
        ? relativeTarget.split("/").slice(1).join("/")
        : relativeTarget
    )
  );

const getFinalTarget = async (entry: Deno.DirEntry, relativeTarget: string) =>
  entry.isSymlink
    ? resolve(dirname(relativeTarget), await Deno.readLink(relativeTarget))
    : resolve(relativeTarget);

export const identical = (
  first: Deno.FileInfo,
  second: Deno.FileInfo
): boolean => first.ino === second.ino && first.dev === second.dev;

export async function* getDotLinks(
  dir: string,
  options: {
    nameRelativeToBase?: boolean;
    recurse?: boolean;
  } = {}
): AsyncGenerator<DotEntry> {
  for await (const entry of Deno.readDir(dir)) {
    const relativeTarget = join(dir, entry.name);

    if (options.recurse && entry.isDirectory) {
      yield* getDotLinks(relativeTarget, options);
    } else {
      yield {
        link: resolvedDotfilePath(relativeTarget, options.nameRelativeToBase),
        target: await getFinalTarget(entry, relativeTarget),
      };
    }
  }
}

export async function* findDotLinks(
  dir: string,
  options: {
    recurse?: boolean;
    filter?: (arg: Deno.DirEntry) => boolean;
  } = {}
): AsyncGenerator<DotEntry> {
  for await (const item of Deno.readDir(dir)) {
    const path = join(dir, item.name);
    if (options.recurse && item.isDirectory) {
      yield* findDotLinks(path, options);
    } else if (item.isSymlink) {
      const target = await Deno.readLink(path);
      if (
        target.startsWith(REPO_LOCATION) &&
        (!options.filter || options.filter(item))
      ) {
        yield {
          link: path,
          target,
        };
      }
    }
  }
}
