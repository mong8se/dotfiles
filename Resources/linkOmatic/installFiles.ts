import { resolve, dirname, join, relative } from "./deps.ts";

import { messageForFile } from "./messages.ts";

import { queueDeletePrompt } from "./deleteFiles.ts";

import { resolveDotFile, isInvalidFileForTarget, identical } from "./fileUtils.ts";

export default async function installFiles() {
  for await (const fileList of [
    findDotFiles("home", { basePathToOmit: "home" }),
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

async function* findDotFiles(
  dir: string,
  options: {
    basePathToOmit?: string;
    recurse?: boolean;
  }
): AsyncGenerator<[string, string], void, void> {
  for await (const entry of Deno.readDir(dir)) {
    let relativeTarget = join(dir, entry.name);
    let dotFile = resolveDotFile(
      options.basePathToOmit
        ? relative(options.basePathToOmit, relativeTarget)
        : relativeTarget
    );

    if (options.recurse && entry.isDirectory) {
      yield* findDotFiles(relativeTarget, options);
    } else {
      isInvalidFileForTarget(entry.name)
        ? messageForFile("ignoring", dotFile)
        : yield [dotFile, resolve(relativeTarget)];
    }
  }
}

const decideLink = async (link: string, target: string): Promise<boolean> => {
  const [linkStats, linkTargetStats, targetStats] = await Promise.allSettled([
    Deno.lstat(link),
    Deno.stat(link),
    Deno.stat(target),
  ]);

  switch (true) {
    case targetStats.status === "rejected":
      messageForFile("skipping", link);
      return false;
    case linkStats.status === "rejected":
      messageForFile("linking", link);
      return true;
    case linkTargetStats.status === "fulfilled" &&
      targetStats.status === "fulfilled" &&
      identical(linkTargetStats.value, targetStats.value):
      messageForFile("", link);
      return false;
    default:
      return await queueDeletePrompt(link, "replac%s");
  }
};
