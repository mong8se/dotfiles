import { resolve, dirname } from "./deps.ts";
import { messageForFile } from "./messages.ts";
import { deletePrompt } from "./deleteFiles.ts";
import {
  findDotFiles,
  identical,
  isInvalidFileToTarget,
} from "./fileUtils.ts";

export default async function installFiles() {
  for await (const fileList of [
    findDotFiles("home", { nameRelativeToBase: true }),
    findDotFiles("config", { recurse: true }),
  ]) {
    for await (const [dotFile, target] of fileList) {
      if (await decideLink(dotFile, target)) {
        const [targetsTarget] = await Promise.allSettled([
          Deno.readLink(target),
          Deno.mkdir(dirname(dotFile), { recursive: true }),
        ]);
        Deno.symlink(
          targetsTarget.status === "fulfilled"
            ? resolve(dirname(target), targetsTarget.value)
            : target,
          dotFile
        );
      }
    }
  }
}

const decideLink = async (link: string, target: string): Promise<boolean> => {
  if (isInvalidFileToTarget(target)) {
    messageForFile("ignoring", link);
    return false;
  }

  const [linkStats, linkTargetStats, targetStats] = await Promise.allSettled([
    Deno.lstat(link),
    Deno.stat(link),
    Deno.stat(target),
  ]);

  if (targetStats.status === "rejected") {
    messageForFile("skipping", link);
    return false;
  } else if (linkStats.status === "rejected") {
    messageForFile("linking", link);
    return true;
  } else if (
    linkTargetStats.status === "fulfilled" &&
    identical(linkTargetStats.value, targetStats.value)
  ) {
    messageForFile("", link);
    return false;
  } else {
    return await deletePrompt(link, "replac%s");
  }
};
