import {
  basename,
  dirname,
  join,
  relative,
  resolve,
} from "https://deno.land/std@0.100.0/path/mod.ts";

import { sprintf } from "https://deno.land/std@0.100.0/fmt/printf.ts";

const usage = () => {
  const __filename = new URL("", import.meta.url);
  console.log(`Usage: ${__filename}

  Commands:
    install
    make_alias_links
    cleanup
    autocleanup
    implode
  `);

  return Promise.resolve();
};

const main = () => {
  if (!THIS.machine) {
    console.warn("Warning: Required environment variable(s) missing");
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
    // return deleteFiles(false, true);
    case "implode":
    // return deleteFiles(true);
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

const REPO_LOCATION = Deno.env.get("REPO_LOCATION");
if (!REPO_LOCATION) {
  console.error("REPO_LOCATION env not set");
  Deno.exit(2);
}

const DOT_LOCATION = Deno.env.get("HOME");
if (!DOT_LOCATION) {
  console.error("DOT_LOCATION env not set");
  Deno.exit(2);
}

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

type AllResponse = boolean | string;
const allValues: Record<string, Promise<AllResponse>> = {};
const setScopeToAll = (scope: string) =>
  (allValues[scope] = Promise.resolve(true));

const queueQuestion = function (query: string, allScope: string) {
  if (!allValues.hasOwnProperty(allScope))
    allValues[allScope] = Promise.resolve(false);

  return queue(() =>
    allValues[allScope]
      .then((all: AllResponse) => (all ? "a" : prompt(query)))
      .then((answer) => {
        if (answer === "a") setScopeToAll(allScope);

        return answer;
      })
  );
};

const decoder = new TextDecoder("utf-8");
type AliasPair = [string, string];
const readAliasFile = () =>
  Deno.readFile(`${REPO_LOCATION}/Resources/aliases.json`)
    .then((aliases: Uint8Array) =>
      JSON.parse(decoder.decode(aliases), (_, value) =>
        typeof value === "string" ? value.replace(/^~/, DOT_LOCATION) : value
      )
    )
    .then((list: Record<string, string>): AliasPair[] =>
      Object.entries(list).map(([link, target]) => [
        resolveDotFile(link),
        resolve(target),
      ])
    );

const makeAliasLinks = () =>
  readAliasFile().then((aliasList: AliasPair[]) =>
    Promise.all(aliasList.map(([link, target]) => decideLink(link, target)))
  );

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

const decideLink = (link: string, target: string) =>
  Promise.allSettled([Deno.lstat(link), Deno.stat(link), Deno.stat(target)])
    .then(([linkStats, linkTargetStats, targetStats]) => {
      if (targetStats.status === "rejected") return "skip";
      if (linkStats.status === "rejected") return "link";
      if (
        linkTargetStats.status === "fulfilled" &&
        linkTargetStats.value.ino === targetStats.value.ino &&
        linkTargetStats.value.dev === targetStats.value.dev
      )
        return "skip";
      return deletePrompt(
        link,
        "decideLink",
        makePrompt("replac%s")
      ).then((deleteMe: boolean) =>
        deleteMe ? Deno.remove(link).then(() => "silentlink") : "silentskip"
      );
    })
    .then((result: string) => {
      switch (result) {
        case "link":
          queueMessage("linking", link);
        case "silentlink":
          Deno.mkdir(dirname(link), { recursive: true }).then(() =>
            Deno.symlink(target, link)
          );
          break;
        case "skip":
          queueMessage("", link);
        default:
          return;
      }
    });

const flatten = ([...list]) => [].concat(...list);
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

  const results: DotEntry[] = [];

  for await (const item of Deno.readDir(dir)) {
    const result: DotEntry = { ...item, path: join(dir, item.name) };
    if (result.isDirectory && recursive) {
      let more = await findDotLinks(result.path, preFilter, recursive);
      results.concat(more);
    } else if (byFilter(result)) {
      results.concat(result);
    }
  }
  return flatten(results);
}

function deleteFiles(implode = false, deleteAll = false) {
  const deleteAllScope = "deleteFiles";
  if (deleteAll) setScopeToAll(deleteAllScope);

  return readAliasFile()
    .then((aliasList: AliasPair[]) =>
      Promise.all(
        aliasList.map(([fileName, correctTarget]) =>
          findDotLinks(
            dirname(fileName),
            (entry: Deno.DirEntry) => entry.name === basename(fileName)
          ).then((list) =>
            deleteCorrectFiles(
              list,
              implode,
              deleteAllScope,
              (target: string) => target === correctTarget
            )
          )
        )
      )
    )
    .then(() =>
      Promise.all([
        findDotLinks(DOT_LOCATION, (item: DotEntry) => item.name.startsWith(".")),
        findDotLinks(join(DOT_LOCATION, ".config"), false, true),
      ])
        .then(flatten)
        .then((list) =>
          deleteCorrectFiles(list, implode, deleteAllScope, (target: string) =>
            target.startsWith(REPO_LOCATION)
          )
        )
    );
}

function deleteCorrectFiles(list: DotEntry[], implode = false, deleteAll: string | undefined , preFilter: Function) {
  const emptyDirectories = {};
  return Promise.all(
    list.map((file: DotEntry) => {
      if (!file.isSymlink) return false;

      return Deno.readLink(file.path).then((target) => {
        if (
          !preFilter(target) ||
          (!implode && !isInvalidFileForTarget(target) && exists(target))
        )
          return false;
        return deletePrompt(file.path, deleteAll).then((deleteMe) => {
          if (!deleteMe) return false;
          let fileDir = dirname(file.path);
          return Deno.remove(file.path)
            .then(() => readDir(fileDir))
            .then((list) => {
              if (list && list.length === 0) emptyDirectories[fileDir] = true;
            });
        });
      });
    })
  ).then(() => {
    return Promise.all(
      Object.keys(emptyDirectories).map((dir) =>
        deletePrompt(
          dir,
          deleteAll,
          makePrompt("remov%s empty directory")
        ).then((deleteMe) => (deleteMe ? Deno.remove(dir) : false))
      )
    );
  });
}

const deletePrompt = (
  fileName: string,
  deleteAllScope: string,
  promptText = makePrompt("delet%s")
) =>
  queueQuestion(
    `${formatMessage(promptText("e"), fileName)}? [ynaq] `,
    deleteAllScope
  ).then((answer) => {
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
  });

const makePrompt = (verb: string) => (ending: string) => sprintf(verb, ending);

if (import.meta.main) {
  main()
    .then(() => console.log("Complete"))
    .catch((e) => console.log("WHOOPS:", e));
  // .finally(() => rl.close());
}
