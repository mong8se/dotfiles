const path = require("path");
const fsBase = require("fs");
const readline = require("readline");
const util = require("util");

const fs = fsBase.promises;
const exists = fsBase.existsSync;

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
});

let pq = Promise.resolve();
const queue = (f) => {
  pq = pq.then(f);
  return pq;
};

const allValues = {};
const activateAll = (scope) => (allValues[scope] = Promise.resolve(true));

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
              if (answer === "a") activateAll(allScope);

              return answer;
            })
            .finally(() => rl.pause())
    )
  );
}.bind(rl);

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

const invalidPattern = new RegExp(`^_(?!${Object.values(THIS).join("|")})`);
const isInvalidFileForTarget = (file) => {
  return invalidPattern.test(path.basename(file));
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

function decideLink(link, target) {
  return Promise.all([
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
          fs.symlink(target, link);
          break;
        case "skip":
          queueMessage("", link);
        default:
          return;
      }
    });
}

function makeAliasLinks() {
  return Promise.all(
    Object.entries(ALIAS_MAPPING).map(([link, target]) =>
      decideLink(link, target)
    )
  );
}

function installFiles(dir, relativeTo = false, recurse = false) {
  return fs.readdir(dir, { withFileTypes: true }).then((list) =>
    Promise.all(
      list.map((entry) => {
        let relativeTarget = path.join(dir, entry.name);
        let dotFile = resolveDotFile(
          relativeTo
            ? path.relative(relativeTo, relativeTarget)
            : relativeTarget
        );
        let targetFile = path.resolve(relativeTarget);

        if (isInvalidFileForTarget(entry.name))
          return queueMessage("ignoring", dotFile);

        if (recurse & entry.isDirectory()) {
          return installDirectory(relativeTarget, relativeTo);
        } else {
          return decideLink(dotFile, targetFile);
        }
      })
    )
  );
}

function installDirectory(dir, relativeTo) {
  return installFiles(dir, relativeTo, true);
}

function findDotLinks(dir, preFilter) {
  let isLink = (item) => item.isSymbolicLink();
  const byFilter = preFilter
    ? (item) => preFilter(item) && isLink(item)
    : isLink;

  return fs.readdir(dir, { withFileTypes: true }).then((list) =>
    list.filter(byFilter).map((item) => {
      item.path = path.join(dir, item.name);
      return item;
    })
  );
}

const flatten = ([...list]) => [].concat(...list);

function findConfigLinks() {
  return fs
    .readdir(path.join(DOT_LOCATION, ".config"), { withFileTypes: true })
    .then((list) =>
      Promise.all(
        list
          .filter((dir) => dir.isDirectory())
          .map((dir) =>
            findDotLinks(path.join(DOT_LOCATION, ".config", dir.name))
          )
      )
    )
    .then(flatten);
}

function deleteFiles(implode = false, deleteAll = false) {
  const deleteAllScope = "deleteFiles";
  if (deleteAll) activateAll(deleteAllScope);

  return Promise.all([
    Promise.all([
      findDotLinks(DOT_LOCATION, (item) => item.name.startsWith(".")),

      findDotLinks(path.join(DOT_LOCATION, ".config")),
      findConfigLinks(),
    ])
      .then(flatten)
      .then((list) =>
        deleteCorrectFiles(list, implode, deleteAllScope, (target) =>
          target.startsWith(REPO_LOCATION)
        )
      ),
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
    ),
  ]);
}

function deleteCorrectFiles(list, implode, deleteAll, validate) {
  return Promise.all(
    list.map((file) => {
      if (!file.isSymbolicLink()) return false;

      return fs.readlink(file.path).then((target) => {
        if (!validate(target)) return false;
        if (!(implode || !exists(target) || isInvalidFileForTarget(target)))
          return false;
        return deletePrompt(file.path, deleteAll).then((deleteMe) => {
          if (!deleteMe) return false;
          let fileDir = path.dirname(file.path);
          return fs.unlink(file.path).then(() =>
            fs.readdir(fileDir).then((list) => {
              if (!list || list.length !== 0) return false;
              return deletePrompt(
                fileDir,
                deleteAll,
                makePrompt("remov%s empty directory")
              ).then((deleteMe) => (deleteMe ? fs.rmdir(fileDir) : false));
            })
          );
        });
      });
    })
  );
}

function deletePrompt(
  fileName,
  deleteAllScope,
  prompt = makePrompt("delet%s")
) {
  return askQuestion(prompt("e"), fileName, deleteAllScope).then((answer) => {
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
}

const formatMessage = (verb, file) =>
  `${verb.padStart(9, " ")} ${
    file.startsWith("/") ? path.relative(DOT_LOCATION, file) : dotBasename(file)
  }`;

const queueMessage = (verb, file) => {
  return queue(() => console.log(formatMessage(verb, file)));
};

function askQuestion(verb, file, scope) {
  return queueQuestion(`${formatMessage(verb, file)}? [ynaq] `, scope);
}

const makePrompt = (verb) => (ending) => util.format(verb, ending);

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
        installDirectory("config"),
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

if (require.main === module) {
  main(process.argv.slice(2))
    .then(() => rl.close())
    .catch((e) => console.log("WHOOPS:", e));
}
