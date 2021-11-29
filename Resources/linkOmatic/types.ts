export type ThisThing = {
  platform: "mac" | "linux" | "unknown";
  machine?: string;
};

export type DotEntry = {
  path: string;
  name: string;
  target: string;
}
