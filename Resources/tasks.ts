import {
  basename,
  dirname,
  join,
  relative,
  resolve,
} from "https://deno.land/std@0.100.0/path/mod.ts";

import { sprintf } from "https://deno.land/std@0.100.0/fmt/printf.ts";

const usage = (warning?: string) => {
  if (warning) console.warn("Warning:", warning);
  console.log(
    `Usage: ${
      new URL("", import.meta.url).pathname
    } Commands: install cleanup autocleanup implode `
  );
  Deno.exit(warning ? 2 : 0);
};

const main = async () => {
  switch (Deno.args[0]) {
    case "install":
      return installFiles();
    case "cleanup":
      return deleteFiles();
    case "autocleanup":
      return deleteFiles({ withoutPrompting: true });
    case "implode":
      return deleteFiles({ implode: true });
    default:
      return usage();
  }
};

const REPO_LOCATION =
  Deno.env.get("REPO_LOCATION")! ||
  usage("REPO_LOCATION environment variable is not set");

const DOT_LOCATION =
  Deno.env.get("HOME")! || usage("HOME environment variable is not set");

type ThisThing = {
  platform: "mac" | "linux" | "unknown";
  machine: string;
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
  machine:
    Deno.env.get("HOST42")! || usage("HOST42 environment variable is not set"),
};

const dotBasename = (file: string) =>
  "." +
  Object.entries(THIS).reduce(
    (value, [label, search]) => value.replace("_" + search, "_" + label),
    file
  );

const resolveDotFile = (file: string) => join(DOT_LOCATION, dotBasename(file));

const invalidPattern = new RegExp(`^_(?!${Object.values(THIS).join("|")})`);
const isInvalidFileForTarget = (file: string) => {
  return invalidPattern.test(basename(file));
};

const formatMessage = (verb: string, file: string) =>
  `${verb.padStart(9, " ")} ${
    file.startsWith("/") ? relative(DOT_LOCATION, file) : dotBasename(file)
  }`;

const messageForFile = (verb: string, file: string) =>
  console.log(formatMessage(verb, file));

const installFiles = async () => {
  for await (const fileList of [
    findDotFiles("home", { basePathToOmit: "home" }),
    findDotFiles("config", { recurse: true }),
  ]) {
    for await (const [dotFile, target] of fileList) {
      if (await decideLink(dotFile, target)) {
        const [targetsTarget] = await Promise.allSettled([
          Deno.readLink(target),
          Deno.mkdir(dirname(dotFile), { recursive: true }),
        ]);
        Deno.symlink(
          targetsTarget.status === "fulfilled"
            ? resolve(dirname(target), targetsTarget.value)
            : target,
          dotFile
        );
      }
    }
  }
};

async function* findDotFiles(
  dir: string,
  options: {
    basePathToOmit?: string;
    recurse?: boolean;
  }
): AsyncGenerator<[string, string], void, void> {
  for await (const entry of Deno.readDir(dir)) {
    let relativeTarget = join(dir, entry.name);
    let dotFile = resolveDotFile(
      options.basePathToOmit
        ? relative(options.basePathToOmit, relativeTarget)
        : relativeTarget
    );

    if (options.recurse && entry.isDirectory) {
      yield* findDotFiles(relativeTarget, options);
    } else {
      isInvalidFileForTarget(entry.name)
        ? messageForFile("ignoring", dotFile)
        : yield [dotFile, resolve(relativeTarget)];
    }
  }
}

const decideLink = async (link: string, target: string): Promise<boolean> => {
  const [linkStats, linkTargetStats, targetStats] = await Promise.allSettled([
    Deno.lstat(link),
    Deno.stat(link),
    Deno.stat(target),
  ]);

  switch (true) {
    case targetStats.status === "rejected":
      messageForFile("skipping", link);
      return false;
    case linkStats.status === "rejected":
      messageForFile("linking", link);
      return true;
    case linkTargetStats.status === "fulfilled" && // @ts-ignore seems to be a TS bug
      identical(linkTargetStats.value, targetStats.value):
      messageForFile("", link);
      return false;
    default:
      return await queueDeletePrompt(link, "replac%s");
  }
};

interface DotEntry extends Deno.DirEntry {
  path: string;
}

async function* findDotLinks(
  dir: string,
  recursive = false
): AsyncGenerator<DotEntry, void, void> {
  for await (const item of Deno.readDir(dir)) {
    const result = item as DotEntry;
    result.path = join(dir, item.name);
    if (result.isDirectory && recursive) {
      yield* findDotLinks(result.path, recursive);
    } else {
      yield result;
    }
  }
}

type DeleteFilesOptions = {
  implode?: boolean;
  withoutPrompting?: boolean;
};
async function deleteFiles(options: DeleteFilesOptions = {}) {
  if (options.withoutPrompting) shouldDelete.all = true;

  for await (const item of findDotLinks(DOT_LOCATION)) {
    if (item.name.startsWith(".")) {
      await decideDelete(item, options.implode);
    }
  }

  const dirs: Set<string> = new Set();
  for await (const item of findDotLinks(join(DOT_LOCATION, ".config"), true)) {
    if (await decideDelete(item, options.implode)) dirs.add(dirname(item.path));
  }

  if (!options.withoutPrompting) shouldDelete.all = false;
  await Promise.all(
    [...dirs].map(async (fileDir: string) => {
      for await (const _ of Deno.readDir(fileDir)) {
        return;
      }

      return await queueDeletePrompt(fileDir, "remov%s empty directory");
    })
  );
}

async function decideDelete(file: DotEntry, implode = false) {
  if (!file.isSymlink) return false;

  const target = await Deno.readLink(file.path);
  if (
    !target.startsWith(REPO_LOCATION) ||
    (!implode && !isInvalidFileForTarget(target) && (await exists(target)))
  )
    return false;

  return await queueDeletePrompt(file.path);
}

const shouldDelete = new Proxy(
  {} as Record<string, Promise<boolean> | boolean>,
  {
    set: (target, prop: string, value: boolean) => {
      target[prop] = Promise.resolve(value);
      return true;
    },
  }
);

const deletePrompt = async (
  fileName: string,
  verbTemplate = "delet%s"
): Promise<boolean> => {
  const conjugateWith = (ending: string): string =>
    sprintf(verbTemplate, ending);

  let answer = (await shouldDelete.all)
    ? "y"
    : prompt(`${formatMessage(conjugateWith("e"), fileName)}? [ynaq?] `);

  switch (answer) {
    case "?":
      deleteHelpMessage();
      return await deletePrompt(fileName, verbTemplate);
    case "q":
      Deno.exit();
    case "a":
      shouldDelete.all = true;
    case "y":
      messageForFile(conjugateWith("ing"), fileName);
      await Deno.remove(fileName);
      return true;
    default:
      messageForFile("skipping", fileName);
      return false;
  }
};

const queue = ((waitForIt: Promise<any>) => async (f: () => Promise<any>) =>
  (waitForIt = waitForIt.then(f)))(Promise.resolve());

function wrapWithQueue(fn: (...args: any) => any) {
  return (...args: Parameters<typeof fn>): ReturnType<typeof fn> =>
    queue(() => fn(...args));
}

const queueDeletePrompt = wrapWithQueue(deletePrompt);

function deleteHelpMessage() {
  console.log(
    `y - yes
n - no
a - all
q - quit`
  );
}

const exists = async (filePath: string): Promise<boolean> => {
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

const identical = (first: Deno.FileInfo, second: Deno.FileInfo): boolean =>
  first.ino === second.ino && first.dev === second.dev;

if (import.meta.main) {
  try {
    await main();
  } catch (e) {
    console.log("WHOOPS:", e);
  }
}
