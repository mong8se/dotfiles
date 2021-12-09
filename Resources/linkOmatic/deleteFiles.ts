import { dirname } from "./deps.ts";
import { queueDeletePrompt } from "./messages.ts";
import { DotEntry } from "./types.ts";
import {
  exists,
  fullDotfilePath,
  isInvalidFileToTarget,
  findDotLinks,
  directoryIsEmpty,
} from "./fileUtils.ts";
import { storeAndGetValue } from "./utils.ts";

const shouldDeleteAll = storeAndGetValue(false);

export default async function deleteFiles(
  options: { implode?: boolean; withoutPrompting?: boolean } = {}
) {
  if (options.withoutPrompting) shouldDeleteAll(true);

  for await (const dotEntry of findDotLinks(fullDotfilePath(), {
    filter: (item) => item.name.startsWith("."),
  })) {
    decideDelete(dotEntry, options.implode);
  }

  const dirs: Set<string> = new Set();
  for await (const dotEntry of findDotLinks(fullDotfilePath(".config"), {
    recursive: true,
  })) {
    if (await decideDelete(dotEntry, options.implode))
      dirs.add(dirname(dotEntry.link));
  }

  if (!options.withoutPrompting) shouldDeleteAll(false);
  await Promise.all(
    [...dirs].map(async (fileDir: string) => {
      if (await directoryIsEmpty(fileDir))
        return deletePrompt(fileDir, "remov%s empty directory");
    })
  );
}

async function decideDelete(file: DotEntry, implode = false) {
  if (
    implode ||
    isInvalidFileToTarget(file.target) ||
    !(await exists(file.target))
  )
    return await deletePrompt(file.link);

  return false;
}

export const deletePrompt = async (
  fileName: string,
  verbTemplate = "delet%s"
): Promise<boolean> => {
  const answer = await queueDeletePrompt(
    fileName,
    verbTemplate,
    shouldDeleteAll()
  );

  switch (answer) {
    case "a":
      shouldDeleteAll(true);
    case "y":
      await Deno.remove(fileName);
      return true;
    default:
      return false;
  }
};
