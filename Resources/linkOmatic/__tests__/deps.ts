// actual dependencies for tests
export { fromFileUrl } from "https://deno.land/std@0.115.1/path/mod.ts";

// copy dependencies from real dependencies
import {
  basename,
  dirname,
  join,
  relative,
  resolve,
} from "https://deno.land/std@0.113.0/path/mod.ts";

import { bold } from "https://deno.land/std@0.113.0/fmt/colors.ts";

import { sprintf } from "https://deno.land/std@0.113.0/fmt/printf.ts";

// export a handle for overriding any of the above imports
const handle: Record<string, any> = {};
export default handle;

const overrideableBasename = (...args: Parameters<typeof basename>) : ReturnType<typeof basename> => {
  //@ts-ignore
  return handle.basename ? handle.basename(...args) : basename(...args)
}
export { overrideableBasename as basename };

const overrideableDirname = (...args: Parameters<typeof dirname>) : ReturnType<typeof dirname> => {
  //@ts-ignore
  return handle.dirname ? handle.dirname(...args) : dirname(...args)
}
export { overrideableDirname as dirname };

const overrideableJoin = (...args: Parameters<typeof join>) : ReturnType<typeof join> => {
  return handle.join ? handle.join(...args) : join(...args)
}
export { overrideableJoin as join };

const overrideableBold = (...args: Parameters<typeof bold>) : ReturnType<typeof bold> => {
  return handle.bold ? handle.bold(...args) : bold(...args)
}
export { overrideableBold as bold };

const overrideableRelative = (...args: Parameters<typeof relative>) : ReturnType<typeof relative> => {
  //@ts-ignore
  return handle.relative ? handle.relative(...args) : relative(...args)
}
export { overrideableRelative as relative };

const overrideableResolve = (...args: Parameters<typeof resolve>) : ReturnType<typeof resolve> => {
  return handle.resolve ? handle.resolve(...args) : resolve(...args)
}
export { overrideableResolve as resolve };

const overrideableSprintf = (...args: Parameters<typeof sprintf>) : ReturnType<typeof sprintf> => {
  return handle.sprintf ? handle.sprintf(...args) : sprintf(...args)
}
export { overrideableSprintf as sprintf };
