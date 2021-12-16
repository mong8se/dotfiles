export type ThisThing = {
  platform: "mac" | "linux" | "unknown";
  machine?: string;
};

const THIS: ThisThing = {
  platform: "unknown",
  machine: "HOST42"
};

export const REPO_LOCATION = "/some/repo";
export const DOT_LOCATION = "/some/home";
export default THIS;
