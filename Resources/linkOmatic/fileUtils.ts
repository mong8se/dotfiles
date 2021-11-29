import { basename, join, relative, resolve } from "./deps.ts";
import { usage } from "./messages.ts";
import { ThisThing, DotEntry } from "./types.ts";

const REPO_LOCATION = envOrBust("REPO_LOCATION");
const DOT_LOCATION = envOrBust("HOME");

const THIS: ThisThing = {
  platform: ((value) => {
    switch (value) {
      case "darwin":
        return "mac";
      case "linux":
        return "linux";
      default:
        return "unknown";
    }
  })(Deno.build.os),
  machine: envOrBust("HOST42"),
};

function envOrBust(name: string): string {
  const ev = Deno.env.get(name);
  if (typeof ev === "string") {
    return ev;
  } else {
    return usage(`Required environment variable "${name}" missing.`);
  }
}

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
): AsyncGenerator<[string, string], void, void> {
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
  recursive = false
): AsyncGenerator<DotEntry, void, void> {
  for await (const item of Deno.readDir(dir)) {
    const path = join(dir, item.name);
    if (item.isDirectory && recursive) {
      yield* findDotLinks(path, recursive);
    } else {
      if (item.isSymlink) {
        const target = await Deno.readLink(path);
        if (target.startsWith(REPO_LOCATION)) {
          yield {
            name: item.name,
            path,
            target,
          }
        }
      }
    }
  }
}
