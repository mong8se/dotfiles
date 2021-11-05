import { basename, join } from "./deps.ts";
import { usage } from "./messages.ts";

const REPO_LOCATION = envOrBust("REPO_LOCATION");
const DOT_LOCATION = envOrBust("HOME");

type ThisThing = {
  platform: "mac" | "linux" | "unknown";
  machine?: string;
};

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

export const dotBasename = (file: string) =>
  "." +
  Object.entries(THIS).reduce(
    (value, [label, search]) => value.replace("_" + search, "_" + label),
    file
  );

const invalidPattern = new RegExp(`^_(?!${Object.values(THIS).join("|")})`);
export const isInvalidFileForTarget = (file: string) => {
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

export const pointsToRepo = (target: string): boolean =>
  target.startsWith(REPO_LOCATION);

export const dotLocation = (subPath?: string) => {
  if (subPath) return join(DOT_LOCATION, subPath);
  return DOT_LOCATION;
};

export const resolveDotFile = (file: string) => dotLocation(dotBasename(file));

export const identical = (
  first: Deno.FileInfo,
  second: Deno.FileInfo
): boolean => first.ino === second.ino && first.dev === second.dev;
