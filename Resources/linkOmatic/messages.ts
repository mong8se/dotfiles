import { relative, bold } from "./deps.ts";

import { dotLocation, dotBasename } from "./fileUtils.ts";

export const formatMessage = (verb: string, file: string) =>
  `${bold(verb.padStart(9, " "))} ${
    file.startsWith("/") ? relative(dotLocation(), file) : dotBasename(file)
  }`;

export const messageForFile = (verb: string, file: string) =>
  console.log(formatMessage(verb, file));

const queue = (
  (waitForIt: Promise<any>) => async (f: () => Promise<any>) =>
    (waitForIt = waitForIt.then(f))
)(Promise.resolve());

export function wrapWithQueue(fn: (...args: any) => any) {
  return (...args: Parameters<typeof fn>): ReturnType<typeof fn> =>
    queue(() => fn(...args));
}

export function deleteHelpMessage() {
  console.log(
    `y - yes
n - no
a - all
q - quit`
  );
}

export const usage = (warning?: string) => {
  if (warning) console.warn("Warning:", warning);
  console.log(
    `Usage: ${
      new URL("", import.meta.url).pathname
    } Commands: install cleanup autocleanup implode `
  );
  Deno.exit(warning ? 2 : 0);
};
