import { fromFileUrl } from "https://deno.land/std@0.115.1/path/mod.ts";

// actual dependencies for tests
import * as deps from "../deps.ts";

const encoder = new TextEncoder();

export const getCurrentFilename = () => fromFileUrl(import.meta.url);

const testDir = deps.dirname(getCurrentFilename());
const filename = deps.join(testDir, "testDeps.ts");

console.log("(Re)creating", filename);

const file = await Deno.open(filename, {
  create: true,
  write: true,
  truncate: true,
});

await Deno.write(
  file.rid,
  encoder.encode(`
// auto generated, do not hand edit!

import { fromFileUrl } from "https://deno.land/std@0.115.1/path/mod.ts";
export const getCurrentFilename = () => fromFileUrl(import.meta.url);

// export a mockRegistry for overriding any of the above imports
const mockRegistry: Record<string, any> = {};
export default mockRegistry;

// copy dependencies from real dependencies
import * as originals from "./originalDeps.ts";
`)
);

await walkDependencies(deps);

Deno.close(file.rid);

async function walkDependencies(deps: any, path?: string): Promise<any> {
  return Promise.all(
    Object.entries(deps).map(async ([prop, value]) => {
      const name = path ? [path, prop].join(".") : prop;
      if (typeof value === "function") {
        return path ? writeNestedMock(name) : writeMock(prop);
      } else if (typeof value === "object") {
        if (path) {
          writeLowerLevelEmptyObject(prop, path);
        } else {
          writeTopLevelEmptyObject(prop);
        }
        walkDependencies(value, name);
      }
    })
  );
}

async function writeMock(prop: string) {
  await Deno.write(
    file.rid,
    encoder.encode(`
 const mockable${prop} = (...args: Parameters<typeof originals.${prop}>) : ReturnType<typeof originals.${prop}> => {
   //@ts-ignore
   return mockRegistry.${prop} ? mockRegistry.${prop}(...args) : originals.${prop}(...args)
 }
export { mockable${prop} as ${prop} };
    `)
  );
}

async function writeNestedMock(prop: string) {
  await Deno.write(
    file.rid,
    encoder.encode(`
   //@ts-ignore
 ${prop} = (...args: Parameters<typeof originals.${prop}>) : ReturnType<typeof originals.${prop}> => {
   //@ts-ignore
   return mockRegistry.${prop} ? mockRegistry.${prop}(...args) : originals.${prop}(...args)
 }
    `)
  );
}

async function writeTopLevelEmptyObject(prop: string) {
  await Deno.write(
    file.rid,
    encoder.encode(`
      export const ${prop} = {} as Record<string, any>;
      mockRegistry.${prop} = {} as Record<string, any>;
    `)
  );
}

async function writeLowerLevelEmptyObject(prop: string, path: string) {
  await Deno.write(
    file.rid,
    encoder.encode(`
      ${path}.${prop} = {};
    `)
  );
}
