import { log } from "./deps.ts";

function envOrBust(name: string): string {
  const ev = Deno.env.get(name);
  if (typeof ev === "string") {
    return ev;
  } else {
    log.error(`Required environment variable "${name}" missing.`);
    Deno.exit(3)
  }
}

export type ThisThing = {
  platform: "mac" | "linux" | "unknown";
  machine?: string;
};

const THIS: ThisThing = {
  platform: ((value) => {
    switch (value) {
      case "darwin":
        return "mac";
      case "linux":
        return "linux";
      default:
        return "unknown";
    }
  })(Deno.build.os),
  machine: envOrBust("HOST42"),
};

export const REPO_LOCATION = envOrBust("REPO_LOCATION");
export const DOT_LOCATION = envOrBust("HOME");
export default THIS;
