import { dirname } from "./deps.ts";
import { queueDeletePrompt } from "./messages.ts";
import { DotEntry } from "./types.ts";
import {
  exists,
  pointsToRepo,
  absoluteDotfile,
  isInvalidFileToTarget,
  findDotLinks,
} from "./fileUtils.ts";

type DeleteFilesOptions = {
  implode?: boolean;
  withoutPrompting?: boolean;
};

export default async function deleteFiles(options: DeleteFilesOptions = {}) {
  if (options.withoutPrompting) shouldDelete.all = true;

  for await (const item of findDotLinks(absoluteDotfile())) {
    if (item.name.startsWith(".")) {
      await decideDelete(item, options.implode);
    }
  }

  const dirs: Set<string> = new Set();
  for await (const item of findDotLinks(absoluteDotfile(".config"), true)) {
    if (await decideDelete(item, options.implode)) dirs.add(dirname(item.path));
  }

  if (!options.withoutPrompting) shouldDelete.all = false;
  await Promise.all(
    [...dirs].map(async (fileDir: string) => {
      for await (const _ of Deno.readDir(fileDir)) {
        return;
      }

      return await deletePrompt(fileDir, "remov%s empty directory");
    })
  );
}

async function decideDelete(file: DotEntry, implode = false) {
  if (!file.isSymlink) return false;

  const target = await Deno.readLink(file.path);
  if (
    pointsToRepo(target) &&
    (implode || isInvalidFileToTarget(target) || !(await exists(target)))
  )
    return await deletePrompt(file.path);

  return false;
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

export const deletePrompt = async (
  fileName: string,
  verbTemplate = "delet%s"
): Promise<boolean> => {
  const answer = await queueDeletePrompt(
    fileName,
    verbTemplate,
    shouldDelete.all
  );

  switch (answer) {
    case "a":
      shouldDelete.all = true;
    case "y":
      await Deno.remove(fileName);
      return true;
    default:
      return false;
  }
};
