import { bold, sprintf } from "./deps.ts";

import { relativeDotfile } from "./fileUtils.ts";

const layoutMessage = (first: string, rest: string) =>
  `${bold(first.padStart(9, " "))} ${rest}`;

const formatMessage = (verb: string, file: string) =>
  layoutMessage(verb, relativeDotfile(file));

export const messageForFile = (verb: string, file: string) =>
  console.log(formatMessage(verb, file));

export const usage = (warning?: string) => {
  if (warning) console.warn("Warning:", warning);
  console.log(
    `Usage: ${
      new URL("", import.meta.url).pathname
    } Commands: install cleanup autocleanup implode `
  );
  Deno.exit(warning ? 2 : 0);
};

function deleteHelpMessage() {
  ["yes", "no", "all", "quit"].forEach((option) =>
    console.log(layoutMessage(option[0], ` - ${option}`))
  );
}

const deletePrompt = async (
  fileName: string,
  verbTemplate = "delet%s",
  deleteAll: Promise<boolean>
): Promise<string> => {
  const conjugateWith = sprintf.bind(null, verbTemplate);

  const answer = (await deleteAll)
    ? "y"
    : prompt(`${formatMessage(conjugateWith("e"), fileName)}? [ynaq?] `);

  switch (answer) {
    case "?":
      deleteHelpMessage();
      return await deletePrompt(fileName, verbTemplate, deleteAll);
    case "a":
    case "y":
      messageForFile(conjugateWith("ing"), fileName);
      return answer;
    case "q":
      Deno.exit();
    default:
      messageForFile("skipping", fileName);
      return "n";
  }
};

const queue = ((waitForIt: Promise<any>) => async (f: () => Promise<any>) =>
  (waitForIt = waitForIt.then(f)))(Promise.resolve());

function wrapWithQueue(fn: (...args: any) => any) {
  return (...args: Parameters<typeof fn>): ReturnType<typeof fn> =>
    queue(() => fn(...args));
}

export const queueDeletePrompt = wrapWithQueue(deletePrompt);
