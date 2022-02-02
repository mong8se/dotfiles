import installFiles from "./installFiles.ts";
import deleteFiles from "./deleteFiles.ts";

import { usage } from "./messages.ts";

import { CommandList } from "./types.ts";

const commands: CommandList = {
  install: installFiles,
  cleanup: deleteFiles,
  autocleanup: deleteFiles.bind(this, { withoutPrompting: true }),
  implode: deleteFiles.bind(this, { implode: true }),
  default: usage,
};

if (import.meta.main) {
  try {
    const command = Deno.args[0];
    command in commands ? commands[command]() : commands.default();
  } catch (e) {
    console.error("Unexpected: ", e);
  }
}
