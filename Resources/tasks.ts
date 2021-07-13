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
  console.log(`Usage: ${new URL("", import.meta.url).pathname}

  Commands:
    install
    make_alias_links
    cleanup
    autocleanup
    implode
  `);

  Deno.exit(warning ? 2 : 0);
};

const main = async () => {
  switch (Deno.args[0]) {
    case "install":
      return Promise.all([
        installFiles("home", "home"),
        installFiles("config", null, true),
      ]);
    case "cleanup":
      return deleteFiles();
    case "autocleanup":
      return deleteFiles(false, true);
    case "implode":
      return deleteFiles(true);
    case "make_alias_links":
      return makeAliasLinks();
    default:
      return usage();
  }
};

const REPO_LOCATION =
  Deno.env.get("REPO_LOCATION")! ||
  usage("REPO_LOCATION environment variable is not set");
const DOT_LOCATION =
  Deno.env.get("HOME")! || usage("HOME environment variable is not set");

const THIS: Record<string, string> = {
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

const queue = ((pq) => (f: () => any) => (pq = pq.then(f)))(Promise.resolve());

const formatMessage = (verb: string, file: string) =>
  `${verb.padStart(9, " ")} ${
    file.startsWith("/") ? relative(DOT_LOCATION, file) : dotBasename(file)
  }`;

const queueMessage = (verb: string, file: string) =>
  queue(() => console.log(formatMessage(verb, file)));

const decoder = new TextDecoder("utf-8");

type AliasPair = [string, string];
const readAliasFile = async (): Promise<AliasPair[]> => {
  const aliases: Uint8Array = await Deno.readFile(
    `${REPO_LOCATION}/Resources/aliases.json`
  );

  const list: Record<string, string> = JSON.parse(
    decoder.decode(aliases),
    (_, value) =>
      typeof value === "string" ? value.replace(/^~/, DOT_LOCATION) : value
  );

  return Object.entries(list).map(
    ([link, target]): AliasPair => [resolveDotFile(link), resolve(target)]
  );
};

const makeAliasLinks = async () => {
  const aliasList: AliasPair[] = await readAliasFile();

  return Promise.all(
    aliasList.map(([link, target]) => decideLink(link, target))
  );
};

const installFiles = async (
  dir: string,
  basePathToOmit?: string | null,
  recurse = false
): Promise<void> => {
  for await (const entry of Deno.readDir(dir)) {
    let relativeTarget = join(dir, entry.name);
    let dotFile = resolveDotFile(
      basePathToOmit ? relative(basePathToOmit, relativeTarget) : relativeTarget
    );

    if (recurse && entry.isDirectory) {
      await installFiles(relativeTarget, basePathToOmit, true);
    } else {
      isInvalidFileForTarget(entry.name)
        ? queueMessage("ignoring", dotFile)
        : await decideLink(dotFile, resolve(relativeTarget));
    }
  }
};

const decideLink = async (link: string, target: string) => {
  const [linkStats, linkTargetStats, targetStats] = await Promise.allSettled([
    Deno.lstat(link),
    Deno.stat(link),
    Deno.stat(target),
  ]);

  let result: string;

  if (targetStats.status === "rejected") result = "skip";
  else if (linkStats.status === "rejected") result = "link";
  else if (
    linkTargetStats.status === "fulfilled" &&
    linkTargetStats.value.ino === targetStats.value.ino &&
    linkTargetStats.value.dev === targetStats.value.dev
  )
    result = "skip";
  else {
    if (await deletePrompt(link, "decideLink", "replac%s")) {
      result = "silentlink";
    } else {
      result = "silentskip";
    }
  }

  switch (result) {
    case "link":
      queueMessage("linking", link);
    case "silentlink":
      await Deno.mkdir(dirname(link), { recursive: true });
      await Deno.symlink(target, link);
      break;
    case "skip":
      queueMessage("", link);
    default:
      return;
  }
};

interface DotEntry extends Deno.DirEntry {
  path: string;
}

async function findDotLinks(
  dir: string,
  action: (file: DotEntry) => void,
  recursive = false,
  preFilter?: (item: Deno.DirEntry) => boolean
): Promise<DotEntry[]> {
  const isLink = (item: Deno.DirEntry) => item.isSymlink;
  const byFilter = preFilter
    ? (item: Deno.DirEntry) => preFilter(item) && isLink(item)
    : isLink;

  let results: DotEntry[] = [];

  try {
    for await (const item of Deno.readDir(dir)) {
      const result: DotEntry = { ...item, path: join(dir, item.name) };
      if (result.isDirectory && recursive) {
        let more = await findDotLinks(
          result.path,
          action,
          recursive,
          preFilter
        );
        results = results.concat(more);
      } else if (byFilter(result)) {
        action(result);
        results.push(result);
      }
    }
  } catch (err) {
    if (err instanceof Deno.errors.NotFound) return [];
    throw err;
  }

  return results;
}

async function deleteFiles(implode = false, deleteAll = false) {
  const deleteAllScope = "deleteFiles";
  if (deleteAll) setScopeToAll(deleteAllScope, true);

  const aliasList: AliasPair[] = await readAliasFile();
  const list = await Promise.all([
    ...aliasList.map(
      async ([fileName, correctTarget]) =>
        await findDotLinks(
          dirname(fileName),
          (file: DotEntry) =>
            deleteFileIfNecessary(
              file,
              implode,
              deleteAllScope,
              (target: string) => target === correctTarget
            ),
          false,
          (entry: Deno.DirEntry) => entry.name === basename(fileName)
        )
    ),
    findDotLinks(
      DOT_LOCATION,
      (file: DotEntry) =>
        deleteFileIfNecessary(file, implode, deleteAllScope, (target: string) =>
          target.startsWith(REPO_LOCATION)
        ),
      false,
      (item: Deno.DirEntry) => item.name.startsWith(".")
    ),
    findDotLinks(
      join(DOT_LOCATION, ".config"),
      (file: DotEntry) =>
        deleteFileIfNecessary(file, implode, deleteAllScope, (target: string) =>
          target.startsWith(REPO_LOCATION)
        ),
      true
    ),
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
      async (dir) =>
        await deletePrompt(dir, deleteAllScope, "remov%s empty directory")
    )
  );
}

async function deleteFileIfNecessary(
  file: DotEntry,
  implode = false,
  deleteAll: string,
  preFilter: (target: string) => boolean
) {
  if (!file.isSymlink) return false;

  try {
    const target = await Deno.readLink(file.path);

    if (!preFilter(target)) return false;

    if (!implode && !isInvalidFileForTarget(target) && (await exists(target)))
      return false;

    return await deletePrompt(file.path, deleteAll);
  } catch (err) {
    if (err instanceof Deno.errors.NotFound) {
      return false;
    }

    throw err;
  }
}

const scopeIsAll: Record<string, Promise<boolean>> = {};
const setScopeToAll = (scope: string, value: boolean) =>
  (scopeIsAll[scope] = Promise.resolve(value));

const deletePrompt = async (
  fileName: string,
  deleteAllScope: string,
  verbTemplate = "delet%s"
) => {
  const conjugateWith = makeConjugator(verbTemplate);

  if (!scopeIsAll.hasOwnProperty(deleteAllScope))
    setScopeToAll(deleteAllScope, false);

  return await queue(async () => {
    let answer = (await scopeIsAll[deleteAllScope])
      ? "y"
      : prompt(`${formatMessage(conjugateWith("e"), fileName)}? [ynaq] `);

    switch (answer) {
      case "q":
        Deno.exit();
      case "a":
        setScopeToAll(deleteAllScope, true);
      case "y":
        console.log(conjugateWith("ing"), fileName);
        await Deno.remove(fileName);
        return true;
      default:
        console.log("skipping", fileName);
        return false;
    }
  });
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
