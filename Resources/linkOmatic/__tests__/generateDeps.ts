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


type Constructor = { new (...args: any[]): any };
function wrapMock<T extends Constructor>(BaseClass: T) {
    return class extends BaseClass {

    }
}
`)
);

await walkDependencies(deps);

Deno.close(file.rid);

async function walkDependencies(deps: any, path: string[] = []): Promise<any> {
  return Promise.all(
    Object.entries(deps).map(async ([prop, value]) => {
      const propPath = [...path, prop];

      if (typeof value === "function") {
        return writeMock(propPath);
      } else if (typeof value === "object") {
        writeEmptyObject(propPath);
        walkDependencies(value, propPath);
      }
    })
  );
}

//  ${prop} = (...args: Parameters<typeof originals.${prop}>) : ReturnType<typeof originals.${prop}> => {
async function writeMock(propPath: string[]) {
  const prop = propPath.join(".");
  if (propPath.length > 1) {
    if (propPath[propPath.length-1].match(/^[A-Z]/)) {
    await Deno.write(
      file.rid,
      encoder.encode(`
 ${prop} = class extends originals.${prop} {
 //@ts-ignore
   constructor(...args) {
     return mockRegistry.${prop} ?
       mockRegistry.${prop}(...args) :
 //@ts-ignore
       super(...args)
   }
 }
    `)
    );
    } else {
    await Deno.write(
      file.rid,
      encoder.encode(`
 ${prop} = function(...args: Parameters<typeof originals.${prop}>) : ReturnType<typeof originals.${prop}> {
   //@ts-ignore
   return mockRegistry.${prop} ? mockRegistry.${prop}(...args) : originals.${prop}(...args)
 }
    `)
    );
        }
  } else {
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
}

async function writeEmptyObject(propPath: string[]) {
  const prop = propPath.join(".");
  if (propPath.length > 1) {
    await Deno.write(
      file.rid,
      encoder.encode(`
      ${prop} = {};
    `)
    );
  } else {
    await Deno.write(
      file.rid,
      encoder.encode(`
      export const ${prop} = {} as Record<string, any>;
      mockRegistry.${prop} = {} as Record<string, any>;
    `)
    );
  }
}
