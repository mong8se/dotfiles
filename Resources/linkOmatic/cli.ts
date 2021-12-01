import installFiles from "./installFiles.ts";
import deleteFiles from "./deleteFiles.ts";

import { usage } from "./messages.ts";

export const commands: Record<string, () => void> = {
  install: installFiles,
  cleanup: deleteFiles,
  autocleanup: deleteFiles.bind(null, { withoutPrompting: true }),
  implode: deleteFiles.bind(null, { implode: true }),
  default: usage,
};

if (import.meta.main) {
  try {
    const command = Deno.args[0];
    (commands[command] || commands["default"])();
  } catch (e) {
    console.error("Unexpected: ", e);
  }
}
