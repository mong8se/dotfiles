import { getCurrentFilename } from "./testDeps.ts";
import { assert, assertEquals, unimplemented } from "https://deno.land/std@0.115.1/testing/asserts.ts";

import * as mock from "./mocks.ts";

Deno.env.set("REPO_LOCATION", "/some/repo");
Deno.env.set("HOME", "/some/home");
Deno.env.set("HOST42", "HOST42");

const self = await import("../fileUtils.ts");

Deno.test("isInvalidFileToTarget is false for no _", () => {
  assert(!
    self.isInvalidFileToTarget("basic"),
    "no underscore is always valid"
  );
});

Deno.test("isInvalidFileToTarget is false for _HOST42", () => {
  assert(!self.isInvalidFileToTarget("_HOST42"));
});

Deno.test("isInvalidFileToTarget is false for _platform", () => {
  assert(!self.isInvalidFileToTarget(`_${Deno.build.os}`));
});

Deno.test("isInvalidFileToTarget is TRUE for _anythingelse", () => {
  assert(self.isInvalidFileToTarget("_abc"));
});

Deno.test("exists is true for this file", async () => {
  const result = await self.exists(getCurrentFilename());

  assert(result);
});

Deno.test("exists is false for bad file", async () => {
  const result = await self.exists("./zzz.zzz");

  assert(!result);
});

Deno.test("fullDotfilePath returns HOME by default", () => {
  assertEquals("/some/home", self.fullDotfilePath());
});

Deno.test("fullDotfilePath returns HOME joined to subpath", () => {
  assertEquals("/some/home/sub/path", self.fullDotfilePath("sub/path"));
});

Deno.test("relativeDotFile returns subpath for fullpath", () => {
  assertEquals("sub/path", self.relativeDotfile("/some/home/sub/path"));
});

Deno.test(
  "relativeDotFile returns calls dotFileNameFromTarget if doesn't start with slash",
  () => {
    assertEquals(".sub/path", self.relativeDotfile("sub/path"));
  }
);

Deno.test("identical returns true for same file", () => {
  const first = mock.FileInfo({
    ino: 99,
    dev: 99,
  });

  const second = mock.FileInfo({
    ino: 99,
    dev: 99,
  });

  assert(self.identical(first, second));
});

Deno.test("identical returns false for different files", () => {
  const first = mock.FileInfo({
    ino: 99,
    dev: 99,
  });

  const second = mock.FileInfo({
    ino: 99,
    dev: 90,
  });

  assert(!self.identical(first, second));
});

Deno.test("getDotFiles to be implemented", () => {
  unimplemented("getDotFiles to be implemented");
});

Deno.test("findSymlinks to be implemented", () => {
  unimplemented("findSymlinks to be implemented");
});
