import {
  basename,
  dirname,
  join,
  relative,
  resolve,
} from "https://deno.land/std@0.100.0/path/mod.ts";

import { sprintf } from "https://deno.land/std@0.100.0/fmt/printf.ts";

const REPO_LOCATION = Deno.env.get("REPO_LOCATION")!;
if (!REPO_LOCATION) {
  console.error("REPO_LOCATION environment variable is not set");
  Deno.exit(2);
}

const DOT_LOCATION = Deno.env.get("HOME")!;
if (!DOT_LOCATION) {
  console.error("HOME environment variable is not set");
  Deno.exit(2);
}

const usage = () => {
  console.log(`Usage: ${new URL("", import.meta.url).pathname}

  Commands:
    install
    make_alias_links
    cleanup
    autocleanup
    implode
  `);

  return Promise.resolve();
};

const main = async () => {
  if (!THIS.machine) {
    console.warn("Warning: HOST42 environment variable is not set");
    return usage();
  }

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

const THIS = {
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
  machine: Deno.env.get("HOST42"),
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

const allValues: Record<string, Promise<boolean>> = {};
const setScopeToAll = (scope: string) =>
  (allValues[scope] = Promise.resolve(true));

const queueQuestion = async function (query: string, allScope: string) {
  if (!allValues.hasOwnProperty(allScope))
    allValues[allScope] = Promise.resolve(false);

  return queue(async () => {
    const all: boolean = await allValues[allScope];
    const answer = all ? "a" : await prompt(query);
    if (answer === "a") setScopeToAll(allScope);

    return answer;
  });
};

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
        ? await queueMessage("ignoring", dotFile)
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
    if (await deletePrompt(link, "decideLink", makePrompt("replac%s"))) {
      await Deno.remove(link);
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
  preFilter: Function | false,
  recursive = false
): Promise<DotEntry[]> {
  const isLink = (item: Deno.DirEntry) => item.isSymlink;
  const byFilter = preFilter
    ? (item: Deno.DirEntry) => preFilter(item) && isLink(item)
    : isLink;

  let results: DotEntry[] = [];

  for await (const item of Deno.readDir(dir)) {
    const result: DotEntry = { ...item, path: join(dir, item.name) };
    if (result.isDirectory && recursive) {
      let more = await findDotLinks(result.path, preFilter, recursive);
      results = results.concat(more);
    } else if (byFilter(result)) {
      results.push(result);
    }
  }

  return results;
}

async function deleteFiles(implode = false, deleteAll = false) {
  const deleteAllScope = "deleteFiles";
  if (deleteAll) setScopeToAll(deleteAllScope);

  const aliasList: AliasPair[] = await readAliasFile();
  await Promise.all(
    aliasList.map(async ([fileName, correctTarget]) => {
      const list = await findDotLinks(
        dirname(fileName),
        (entry: Deno.DirEntry) => entry.name === basename(fileName)
      );

      return deleteCorrectFiles(
        list,
        implode,
        deleteAllScope,
        (target: string) => target === correctTarget
      );
    })
  );

  const list = await Promise.all([
    findDotLinks(DOT_LOCATION, (item: DotEntry) => item.name.startsWith(".")),
    findDotLinks(join(DOT_LOCATION, ".config"), false, true),
  ]);

  return deleteCorrectFiles(
    list.flat(),
    implode,
    deleteAllScope,
    (target: string) => target.startsWith(REPO_LOCATION)
  );
}

async function deleteCorrectFiles(
  list: DotEntry[],
  implode = false,
  deleteAll: string,
  preFilter: Function
) {
  const emptyDirectories: Record<string, boolean> = {};

  await Promise.all(
    list.map(async (file: DotEntry) => {
      if (!file.isSymlink) return false;

      const target = await Deno.readLink(file.path);

      if (!preFilter(target)) return false;

      const targetExists = await exists(target);

      if (!implode && !isInvalidFileForTarget(target) && exists(target))
        return false;

      const deleteMe = await deletePrompt(file.path, deleteAll);

      if (!deleteMe) return false;

      let fileDir = dirname(file.path);

      await Deno.remove(file.path);

      let dirIsEmpty = true;
      for await (const dirEntry of Deno.readDir(fileDir)) {
        dirIsEmpty = false;
        break;
        console.log("never");
      }

      if (dirIsEmpty) emptyDirectories[fileDir] = true;
    })
  );

  await Promise.all(
    Object.keys(emptyDirectories).map(async (dir) => {
      const deleteMe = await deletePrompt(
        dir,
        deleteAll,
        makePrompt("remov%s empty directory")
      );

      if (deleteMe) Deno.remove(dir);
    })
  );
}

const deletePrompt = async (
  fileName: string,
  deleteAllScope: string,
  promptText = makePrompt("delet%s")
) => {
  const answer = await queueQuestion(
    `${formatMessage(promptText("e"), fileName)}? [ynaq] `,
    deleteAllScope
  );

  switch (answer) {
    case "y":
    case "a":
      console.log(promptText("ing"), fileName);
      return true;
    case "q":
      Deno.exit();
    default:
      console.log("skipping", fileName);
      return false;
  }
};

const makePrompt = (verb: string) => (ending: string) => sprintf(verb, ending);

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
