import { bold, sprintf } from "./deps.ts";

import { commands } from "./cli.ts";

import { relativeDotfile } from "./fileUtils.ts";

import * as log from "https://deno.land/std@0.116.0/log/mod.ts";

await log.setup({
  handlers: {
    functionFmt: new log.handlers.ConsoleHandler("DEBUG", {
      formatter: (logRecord: log.LogRecord) => {
        const data = logRecord.args.slice() as string[];
        if (logRecord.loggerName === "fileLogger" && logRecord.args.length) {
          data[0] = relativeDotfile(data[0] as string);
        }

        return layoutMessage(logRecord.msg, ...data);
      },
    }),
  },
  loggers: {
    default: {
      level: "INFO",
      handlers: ["functionFmt"],
    },
    fileLogger: {
      level: "INFO",
      handlers: ["functionFmt"],
    },
  },
});

export const fileLog = log.getLogger("fileLogger");

const layoutMessage = (first: string, ...rest: string[]) =>
  sprintf("% 18s %s", bold(first), rest.join(" | "));

export const usage = (warning?: string) => {
  if (warning) log.warning("Warning:", warning);
  log.info("Usage:", new URL("", import.meta.url).pathname, "<command>", "\n");
  log.info("Commands:", ...Object.keys(commands), "\n");
  Deno.exit(warning ? 2 : 0);
};

function deleteHelpMessage() {
  ["yes", "no", "all", "quit"].forEach((option) =>
    log.info(option[0], `- ${option}`)
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
    : prompt(
        `${layoutMessage(
          conjugateWith("e"),
          relativeDotfile(fileName)
        )}? [ynaq?] `
      );

  switch (answer) {
    case "?":
      deleteHelpMessage();
      return await deletePrompt(fileName, verbTemplate, deleteAll);
    case "a":
    case "y":
      fileLog.info(conjugateWith("ing"), fileName);
      return answer;
    case "q":
      Deno.exit();
    default:
      fileLog.info("skipping", fileName);
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
