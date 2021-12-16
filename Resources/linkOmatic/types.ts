export type DotEntry = {
  link: string;
  target: string;
};

export type DeleteOptions = {
  implode: boolean;
  withoutPrompting: boolean;
  verbTemplate: string;
};

export interface CommandList {
  [key: string]: () => void;
}
