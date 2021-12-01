import { usage } from "./messages.ts";

function envOrBust(name: string): string {
  const ev = Deno.env.get(name);
  if (typeof ev === "string") {
    return ev;
  } else {
    return usage(`Required environment variable "${name}" missing.`);
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
