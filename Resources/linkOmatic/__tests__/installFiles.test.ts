import mockRegistry, { getCurrentFilename } from "./testDeps.ts";
import {
  assert,
  assertEquals,
} from "https://deno.land/std@0.115.1/testing/asserts.ts";

import sinon from "https://cdn.skypack.dev/sinon@11.1.2?dts";

import * as mock from "./mocks.ts";

import installFiles from  "../installFiles.ts";

// const mkdir = Deno.mkdir;
// const symlink = Deno.symlink;
// Deno.mkdir = sinon.stub()
// Deno.symlink = sinon.stub()
//

const sym = sinon.fake()
const fakeMkdir = sinon.replace(Deno, "mkdir", sinon.fake());
const fakeSymlink = sinon.replace(Deno, "symlink", sym);

Deno.test("installFiles ", async () => {
    const cleanupReadDir = mock.makeMockReadDir([
    { 
      name: "home",
      isDirectory: true,
      entries: [
        {
          name: "miss",
          isFile: true,
        },
        {
          name: "elizabeth",
          isFile: true,
        }
      ]
    },
      {
        name: "config",
        isDirectory: true,
        entries: [
          {
            name: "macho",
            isDirectory: true,
            entries: [
              {
                name: "man",
                isFile: true,
                isSymlink: true,
              },
            ],
          },
        ],
      },
    ]);

    await installFiles()

    assertEquals( sym.callCount, 1 )

    cleanupReadDir();
});


// Deno.mkdir = mkdir;
// Deno.symlink = symlink;
