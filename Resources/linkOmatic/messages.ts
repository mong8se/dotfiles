import { bold, log, sprintf } from "./deps.ts";

import { relativeDotfile } from "./fileUtils.ts";

import { CommandList, DeleteOptions } from "./types.ts";

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

export function usage(this: CommandList, warning?: string) {
  if (warning) log.warning("Warning:", warning);
  log.info("Usage:", new URL("", import.meta.url).pathname, "<command>", "\n");
  log.info("CommandLists:", ...Object.keys(this), "\n");
  Deno.exit(warning ? 2 : 0);
};

function deleteHelpMessage() {
  ["yes", "no", "all", "quit"].forEach((option) =>
    log.info(option[0], `- ${option}`)
  );
}

export const formatDeletePrompt = (
  fileName: string,
  options: DeleteOptions
): string => {
  const conjugateWith = sprintf.bind(null, options.verbTemplate);

  const answer = prompt(
    `${layoutMessage(conjugateWith("e"), relativeDotfile(fileName))}? [ynaq?] `
  );

  switch (answer) {
    case "?":
      deleteHelpMessage();
      return formatDeletePrompt(fileName, options);
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
