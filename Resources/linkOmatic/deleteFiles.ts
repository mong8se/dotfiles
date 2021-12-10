import { dirname } from "./deps.ts";
import { formatDeletePrompt } from "./messages.ts";
import { DeleteOptions, DotEntry } from "./types.ts";
import {
  exists,
  fullDotfilePath,
  isInvalidFileToTarget,
  findDotLinks,
  directoryIsEmpty,
} from "./fileUtils.ts";
import { storeAndGetValue, StoreAndGetValue } from "./utils.ts";

export default async function deleteFiles(opts: Partial<DeleteOptions> = {}) {
  const options: DeleteOptions = {
    implode: false,
    withoutPrompting: false,
    verbTemplate: "delet%s",
    ...opts,
  };

  for await (const dotEntry of findDotLinks(fullDotfilePath(), {
    filter: (item) => item.name.startsWith("."),
  })) {
    decideDelete(dotEntry, options);
  }

  const dirs: Set<string> = new Set();
  for await (const dotEntry of findDotLinks(fullDotfilePath(".config"), {
    recursive: true,
  })) {
    if (await decideDelete(dotEntry, options)) dirs.add(dirname(dotEntry.link));
  }

  await Promise.all(
    [...dirs].map(async (fileDir: string) => {
      if (await directoryIsEmpty(fileDir))
        return deletePrompt(fileDir, {
          ...options,
          verbTemplate: "remov%s empty directory",
        });
    })
  );
}

async function decideDelete(file: DotEntry, options: DeleteOptions) {
  if (
    options.implode ||
    isInvalidFileToTarget(file.target) ||
    !(await exists(file.target))
  )
    return await deletePrompt(file.link, options);

  return false;
}

let queueDeletePrompt: StoreAndGetValue<boolean>;

export const deletePrompt = async (
  fileName: string,
  options: DeleteOptions
): Promise<boolean> => {
  const { withoutPrompting } = options;

  if (!queueDeletePrompt) {
    queueDeletePrompt = storeAndGetValue(withoutPrompting);
  }

  return await queueDeletePrompt(
    async (shouldDeleteAll, setShouldDeleteAll) => {
      const answer = shouldDeleteAll ? "y" : formatDeletePrompt(
        fileName,
        options
      );

      switch (answer) {
        case "a":
          setShouldDeleteAll(true);
        case "y":
          await Deno.remove(fileName);
          return true;
        default:
          return false;
      }
    }
  );
};
