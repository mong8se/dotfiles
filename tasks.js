const path = require("path");
const fsBase = require("fs");
const readline = require("readline");
const util = require("util");

const fs = fsBase.promises;
const exists = fsBase.existsSync;

function usage() {
  console.log(`Usage: ${__filename}

  Commands:
    install
    make_alias_links
    cleanup
    autocleanup
    implode
  `);

  return Promise.resolve();
}

const main = (args) => {
  if (!THIS.machine) {
    console.warn("Warning: HOST42 environment variable is not set");
    return usage();
  }

  switch (args[0]) {
    case "install":
      return Promise.all([
        installFiles("home", "home"),
        installFiles("config", false, true),
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

const REPO_LOCATION = __dirname;
const DOT_LOCATION = process.env.HOME;
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
  })(process.platform),
  machine: process.env.HOST42.trim(),
};

const dotBasename = (file) =>
  "." +
  Object.entries(THIS).reduce(
    (value, [label, search]) => value.replace("_" + search, "_" + label),
    file
  );

const resolveDotFile = (file) => path.join(DOT_LOCATION, dotBasename(file));

const ALIAS_MAPPING = {
  [resolveDotFile("vim")]: resolveDotFile("config/nvim"),
  [resolveDotFile("vimrc")]: resolveDotFile("config/nvim/init.vim"),
  [resolveDotFile("config/nvim/autoload/plug.vim")]: path.resolve(
    "Resources/vim-plug/plug.vim"
  ),
};

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

const queue = ((pq) => (f) => (pq = pq.then(f)))(Promise.resolve());

const formatMessage = (verb, file) =>
  `${verb.padStart(9, " ")} ${
    file.startsWith("/") ? path.relative(DOT_LOCATION, file) : dotBasename(file)
  }`;

const queueMessage = (verb, file) =>
  queue(() => console.log(formatMessage(verb, file)));

const allValues = {};
const setScopeToAll = (scope) => (allValues[scope] = Promise.resolve(true));

const queueQuestion = function (query, allScope) {
  if (!allValues.hasOwnProperty(allScope))
    allValues[allScope] = Promise.resolve(false);

  return queue(() =>
    allValues[allScope].then((all) =>
      all
        ? "a"
        : new Promise((resolve, reject) => {
            try {
              rl.question(query, resolve);
            } catch (err) {
              reject(err);
            }
          })
            .then((answer) => {
              if (answer === "a") setScopeToAll(allScope);

              return answer;
            })
            .finally(() => rl.pause())
    )
  );
}.bind(rl);

const invalidPattern = new RegExp(`^_(?!${Object.values(THIS).join("|")})`);
const isInvalidFileForTarget = (file) => {
  return invalidPattern.test(path.basename(file));
};

const decideLink = (link, target) =>
  Promise.all([
    fs.lstat(link).catch(() => false),
    fs.stat(link).catch(() => false),
    fs.stat(target).catch(() => false),
  ])
    .then(([linkStats, linkTargetStats, targetStats]) => {
      if (!targetStats) return "skip";
      if (!linkStats) return "link";
      if (
        linkTargetStats.ino === targetStats.ino &&
        linkTargetStats.dev === targetStats.dev
      )
        return "skip";
      return deletePrompt(
        link,
        "decideLink",
        makePrompt("replac%s")
      ).then((deleteMe) =>
        deleteMe ? fs.unlink(link).then(() => "silentlink") : "silentskip"
      );
    })
    .then((result) => {
      switch (result) {
        case "link":
          queueMessage("linking", link);
        case "silentlink":
          fs.mkdir(path.dirname(link), { recursive: true }).then(() =>
            fs.symlink(target, link)
          );
          break;
        case "skip":
          queueMessage("", link);
        default:
          return;
      }
    });

const makeAliasLinks = () =>
  Promise.all(
    Object.entries(ALIAS_MAPPING).map(([link, target]) =>
      decideLink(link, target)
    )
  );

const installFiles = (dir, basePathToOmit = false, recurse = false) =>
  fs.readdir(dir, { withFileTypes: true }).then((list) =>
    Promise.all(
      list.map((entry) => {
        let relativeTarget = path.join(dir, entry.name);
        let dotFile = resolveDotFile(
          basePathToOmit
            ? path.relative(basePathToOmit, relativeTarget)
            : relativeTarget
        );
        let targetFile = path.resolve(relativeTarget);

        if (isInvalidFileForTarget(entry.name))
          return queueMessage("ignoring", dotFile);

        if (recurse & entry.isDirectory()) {
          return installFiles(relativeTarget, basePathToOmit, true);
        } else {
          return decideLink(dotFile, targetFile);
        }
      })
    )
  );

const flatten = ([...list]) => [].concat(...list);

function findDotLinks(dir, preFilter, recursive = false) {
  const isLink = (item) => item.isSymbolicLink();
  const byFilter = preFilter
    ? (item) => preFilter(item) && isLink(item)
    : isLink;

  return fs.readdir(dir, { withFileTypes: true }).then((list) =>
    Promise.all(
      list.map((item) => {
        item.path = path.join(dir, item.name);
        if (item.isDirectory() && recursive) {
          return findDotLinks(item.path, preFilter, recursive);
        }
        if (byFilter(item)) {
          return item;
        }
        return [];
      })
    ).then(flatten)
  );
}

function deleteFiles(implode = false, deleteAll = false) {
  const deleteAllScope = "deleteFiles";
  if (deleteAll) setScopeToAll(deleteAllScope);

  return Promise.all(
    Object.entries(ALIAS_MAPPING).map(([fileName, correctTarget]) =>
      findDotLinks(
        path.dirname(fileName),
        (entry) => entry.name === path.basename(fileName)
      ).then((list) =>
        deleteCorrectFiles(
          list,
          implode,
          deleteAllScope,
          (target) => target === correctTarget
        )
      )
    )
  ).then(() =>
    Promise.all([
      findDotLinks(DOT_LOCATION, (item) => item.name.startsWith(".")),
      findDotLinks(path.join(DOT_LOCATION, ".config"), false, true),
    ])
      .then(flatten)
      .then((list) =>
        deleteCorrectFiles(list, implode, deleteAllScope, (target) =>
          target.startsWith(REPO_LOCATION)
        )
      )
  );
}

function deleteCorrectFiles(list, implode, deleteAll, preFilter) {
  const emptyDirectories = {};
  return Promise.all(
    list.map((file) => {
      if (!file.isSymbolicLink()) return false;

      return fs.readlink(file.path).then((target) => {
        if (
          !preFilter(target) ||
          (!implode && !isInvalidFileForTarget(target) && exists(target))
        )
          return false;
        return deletePrompt(file.path, deleteAll).then((deleteMe) => {
          if (!deleteMe) return false;
          let fileDir = path.dirname(file.path);
          return fs
            .unlink(file.path)
            .then(() => fs.readdir(fileDir))
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
        ).then((deleteMe) => (deleteMe ? fs.rmdir(dir) : false))
      )
    );
  });
}

const deletePrompt = (
  fileName,
  deleteAllScope,
  prompt = makePrompt("delet%s")
) =>
  queueQuestion(
    `${formatMessage(prompt("e"), fileName)}? [ynaq] `,
    deleteAllScope
  ).then((answer) => {
    switch (answer) {
      case "y":
      case "a":
        console.log(prompt("ing"), fileName);
        return true;
      case "q":
        process.exit();
      default:
        console.log("skipping", fileName);
        return false;
    }
  });

const makePrompt = (verb) => (ending) => util.format(verb, ending);

if (require.main === module) {
  main(process.argv.slice(2))
    .catch((e) => console.log("WHOOPS:", e))
    .finally(() => rl.close());
}
