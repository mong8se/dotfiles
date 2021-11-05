import { dirname, join, sprintf } from "./deps.ts";
import {
  wrapWithQueue,
  deleteHelpMessage,
  formatMessage,
  messageForFile,
} from "./messages.ts";
import { DotEntry } from "./types.ts";
import {
  exists,
  pointsToRepo,
  dotLocation,
  isInvalidFileForTarget,
} from "./fileUtils.ts";

type DeleteFilesOptions = {
  implode?: boolean;
  withoutPrompting?: boolean;
};

export default async function deleteFiles(options: DeleteFilesOptions = {}) {
  if (options.withoutPrompting) shouldDelete.all = true;

  for await (const item of findDotLinks(dotLocation())) {
    if (item.name.startsWith(".")) {
      await decideDelete(item, options.implode);
    }
  }

  const dirs: Set<string> = new Set();
  for await (const item of findDotLinks(dotLocation(".config"), true)) {
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

async function decideDelete(file: DotEntry, implode = false) {
  if (!file.isSymlink) return false;

  const target = await Deno.readLink(file.path);
  if (
    !pointsToRepo(target) ||
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

export const queueDeletePrompt = wrapWithQueue(deletePrompt);
