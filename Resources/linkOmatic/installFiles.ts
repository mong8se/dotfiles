import { dirname } from "./deps.ts";
import { fileLog } from "./messages.ts";
import { deletePrompt } from "./deleteFiles.ts";
import { getDotLinks, identical, isInvalidFileToTarget } from "./fileUtils.ts";

export default async function installFiles() {
  for await (const fileList of [
    getDotLinks("home", { nameRelativeToBase: true }),
    getDotLinks("config", { recurse: true }),
  ]) {
    for await (const [dotFile, target] of fileList) {
      if (await decideLink(target, dotFile)) {
        await Deno.mkdir(dirname(dotFile), { recursive: true });
        Deno.symlink(target, dotFile);
      }
    }
  }
}

const decideLink = async (target: string, link: string): Promise<boolean> => {
  if (isInvalidFileToTarget(target)) {
    fileLog.info("ignoring", link);
    return false;
  }

  let linkStats, linkTargetStats, oldLink, newTargetStats;

  try {
    newTargetStats = await Deno.stat(target);
  } catch {
    fileLog.info("skipping", link);
    return false;
  }

  try {
    linkStats = await Deno.lstat(link);
  } catch {
    fileLog.info("linking", link);
    return true;
  }

  try {
    linkTargetStats = await Deno.stat(link);
    if (identical(linkTargetStats, newTargetStats)) {
      fileLog.info("", link);
      return false;
    }
  } catch {
    linkTargetStats = false;
  }

  try {
    if (linkStats.isSymlink) oldLink = await Deno.readLink(link);
  } catch {
    oldLink = false;
  }

  if (oldLink) {
    fileLog.warning(
      "found",
      link,
      `Link already exists and points elsewhere: ${oldLink} ${
        linkTargetStats ? "" : "(dead)"
      }`
    );
  } else {
    fileLog.warning("found", link, `File exists and is not a link`);
  }

  return await deletePrompt(link, "replac%s");
};
