import installFiles from "./installFiles.ts";
import deleteFiles from "./deleteFiles.ts";

import { usage } from "./messages.ts";

const main = async () => {
  switch (Deno.args[0]) {
    case "install":
      return installFiles();
    case "cleanup":
      return deleteFiles();
    case "autocleanup":
      return deleteFiles({ withoutPrompting: true });
    case "implode":
      return deleteFiles({ implode: true });
    default:
      return usage();
  }
};

if (import.meta.main) {
  try {
    await main();
  } catch (e) {
    console.error("Unexpected: ", e);
  }
}
