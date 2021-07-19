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
      return Promise.all([
        installFiles("home", { basePathToOmit: "home" }),
        installFiles("config", { recurse: true }),
      ]);
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

type InstallOptions = {
  basePathToOmit?: string;
  recurse?: boolean;
};
const installFiles = async (
  dir: string,
  options: InstallOptions
): Promise<void> => {
  for await (const entry of Deno.readDir(dir)) {
    let relativeTarget = join(dir, entry.name);
    let dotFile = resolveDotFile(
      options.basePathToOmit
        ? relative(options.basePathToOmit, relativeTarget)
        : relativeTarget
    );

    if (options.recurse && entry.isDirectory) {
      await installFiles(relativeTarget, options);
    } else {
      isInvalidFileForTarget(entry.name)
        ? messageForFile("ignoring", dotFile)
        : await decideLink(dotFile, resolve(relativeTarget));
    }
  }
};

const decideLink = async (link: string, target: string) => {
  const [
    linkStats,
    linkTargetStats,
    targetStats,
    targetsTarget,
  ] = await Promise.allSettled([
    Deno.lstat(link),
    Deno.stat(link),
    Deno.stat(target),
    Deno.readLink(target),
  ]);

  let result: string;
  if (targetStats.status === "rejected") result = "skip";
  else if (linkStats.status === "rejected") result = "link";
  else if (
    linkTargetStats.status === "fulfilled" &&
    linkTargetStats.value.ino === targetStats.value.ino &&
    linkTargetStats.value.dev === targetStats.value.dev
  ) {
    result = "skip";
  } else {
    if (await queueDeletePrompt(link, "replac%s")) {
      result = "silentlink";
    } else {
      result = "silentskip";
    }
  }

  switch (result) {
    case "link":
      messageForFile("linking", link);
    case "silentlink":
      await Deno.mkdir(dirname(link), { recursive: true });
      await Deno.symlink(
        targetsTarget.status === "fulfilled"
          ? resolve(dirname(target), targetsTarget.value)
          : target,
        link
      );
      break;
    case "skip":
      messageForFile("", link);
    default:
      return;
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
  if (options.withoutPrompting) setShouldDeleteAll();

  for await (const item of findDotLinks(DOT_LOCATION)) {
    if (item.name.startsWith(".")) {
      await deleteFileIfNecessary(item, options.implode);
    }
  }

  const dirs: Set<string> = new Set();
  for await (const item of findDotLinks(join(DOT_LOCATION, ".config"), true)) {
    if (await deleteFileIfNecessary(item, options.implode))
      dirs.add(dirname(item.path));
  }

  await Promise.all(
    [...dirs].map(async (fileDir: string) => {
      for await (const _ of Deno.readDir(fileDir)) {
        return;
      }

      return await queueDeletePrompt(fileDir, "remov%s empty directory")
    })
  );
}

async function deleteFileIfNecessary(file: DotEntry, implode = false) {
  if (!file.isSymlink) return false;

  const target = await Deno.readLink(file.path);
  if (!target.startsWith(REPO_LOCATION)) return false;

  if (!implode && !isInvalidFileForTarget(target) && (await exists(target))) {
    return false;
  }

  return await queueDeletePrompt(file.path);
}

let shouldDeleteAll = Promise.resolve(false);
const setShouldDeleteAll = () => (shouldDeleteAll = Promise.resolve(true));

const deletePrompt = async (
  fileName: string,
  verbTemplate = "delet%s"
): Promise<boolean> => {
  const conjugateWith = (ending: string): string =>
    sprintf(verbTemplate, ending);

  let answer = (await shouldDeleteAll)
    ? "y"
    : prompt(`${formatMessage(conjugateWith("e"), fileName)}? [ynaq?] `);

  switch (answer) {
    case "?":
      deleteHelpMessage();
      return await deletePrompt(fileName, verbTemplate);
    case "q":
      Deno.exit();
    case "a":
      setShouldDeleteAll();
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

const queueDeletePrompt = async (
  ...args: Parameters<typeof deletePrompt>
): ReturnType<typeof deletePrompt> =>
  queue(() => {
    return deletePrompt(...args);
  });

function deleteHelpMessage() {
  console.log(
    `y - yes
n - no
a - all
q - quit`
  );
}

async function exists(filePath: string): Promise<boolean> {
  try {
    await Deno.lstat(filePath);
    return true;
  } catch (err) {
    if (err instanceof Deno.errors.NotFound) {
      return false;
    }
    throw err;
  }
}

if (import.meta.main) {
  try {
    await main();
  } catch (e) {
    console.log("WHOOPS:", e);
  }
}
