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

const queue = ((pq: Promise<any>) => (f: () => any) =>
  pq.then(() => (pq = Promise.resolve(f()))))(Promise.resolve());

const queueMessage = (text: string) => queue(() => console.log(text));

const formatMessage = (verb: string, file: string) =>
  `${verb.padStart(9, " ")} ${
    file.startsWith("/") ? relative(DOT_LOCATION, file) : dotBasename(file)
  }`;

const queueMessageForFile = (verb: string, file: string) =>
  queueMessage(formatMessage(verb, file));

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
        ? await queueMessageForFile("ignoring", dotFile)
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
    if (await deletePrompt(link, "replac%s")) {
      result = "silentlink";
    } else {
      result = "silentskip";
    }
  }

  switch (result) {
    case "link":
      await queueMessageForFile("linking", link);
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
      await queueMessageForFile("", link);
    default:
      return;
  }
};

interface DotEntry extends Deno.DirEntry {
  path: string;
}

type DirEntryFilter = (item: Deno.DirEntry) => boolean;
type FindDotLinksOptions = {
  implode?: boolean;
  recursive?: boolean;
  preFilter?: DirEntryFilter;
};

async function findDotLinks(
  dir: string,
  options: FindDotLinksOptions
): Promise<DotEntry[]> {
  let results: DotEntry[] = [];

  try {
    for await (const item of Deno.readDir(dir)) {
      const result = item as DotEntry;
      result.path = join(dir, item.name);
      if (result.isDirectory && options.recursive) {
        let more = await findDotLinks(result.path, options);
        results = results.concat(more);
      } else if (options.preFilter ? options.preFilter(result) : true) {
        if (await deleteFileIfNecessary(result, options.implode)) {
          results.push(result);
        }
      }
    }
  } catch (err) {
    if (err instanceof Deno.errors.NotFound) return [];
    throw err;
  }

  return results;
}

type DeleteFilesOptions = {
  implode?: boolean;
  withoutPrompting?: boolean;
};
async function deleteFiles(options: DeleteFilesOptions = {}) {
  if (options.withoutPrompting) setShouldDeleteAll();

  const list = await Promise.all([
    findDotLinks(DOT_LOCATION, {
      implode: options.implode,
      preFilter: (item: Deno.DirEntry) => item.name.startsWith("."),
    }),
    findDotLinks(join(DOT_LOCATION, ".config"), {
      implode: options.implode,
      recursive: true,
    }),
  ]);

  const emptyDirectories: Record<string, boolean> = {};
  await Promise.all(
    list.flat().map(async (file) => {
      let fileDir = dirname(file.path);
      if (emptyDirectories[fileDir] === true) return;
      for await (const _ of Deno.readDir(fileDir)) {
        return;
      }
      emptyDirectories[fileDir] = true;
    })
  );

  await Promise.all(
    Object.keys(emptyDirectories).map(
      async (dir) => await deletePrompt(dir, "remov%s empty directory")
    )
  );
}

async function deleteFileIfNecessary(file: DotEntry, implode = false) {
  if (!file.isSymlink) return false;

  try {
    const target = await Deno.readLink(file.path);
    if (!target.startsWith(REPO_LOCATION)) return false;

    if (!implode && !isInvalidFileForTarget(target) && (await exists(target))) {
      return false;
    }

    return await deletePrompt(file.path);
  } catch (err) {
    if (err instanceof Deno.errors.NotFound) {
      return false;
    }

    throw err;
  }
}

let shouldDeleteAll = Promise.resolve(false);
const setShouldDeleteAll = () => (shouldDeleteAll = Promise.resolve(true));

const queuePrompt = (text: string) => queue(() => prompt(text));

const deletePrompt = async (
  fileName: string,
  verbTemplate = "delet%s"
): Promise<boolean> => {
  const conjugateWith = makeConjugator(verbTemplate);

  let answer = (await shouldDeleteAll)
    ? "y"
    : await queuePrompt(
        `${formatMessage(conjugateWith("e"), fileName)}? [ynaq?] `
      );

  switch (answer) {
    case "?":
      await queueMessage(
        // prettier -ignore
        `y - yes
 n - no`
      );
      return await deletePrompt(fileName, verbTemplate);
    case "q":
      Deno.exit();
    case "a":
      setShouldDeleteAll();
    case "y":
      await queueMessageForFile(conjugateWith("ing"), fileName);
      await Deno.remove(fileName);
      return true;
    default:
      await queueMessageForFile("skipping", fileName);
      return false;
  }
};

const makeConjugator = (verb: string) => (ending: string) =>
  sprintf(verb, ending);

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
