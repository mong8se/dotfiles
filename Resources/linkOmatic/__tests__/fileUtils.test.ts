import mockRegistry, { getCurrentFilename } from "./testDeps.ts";
import {
  assert,
  assertEquals,
} from "https://deno.land/std@0.115.1/testing/asserts.ts";

import * as mock from "./mocks.ts";

const self = await import("../fileUtils.ts");

Deno.test("isInvalidFileToTarget is false for no _", () => {
  assert(!self.isInvalidFileToTarget("basic"), "no underscore is always valid");
});

Deno.test("isInvalidFileToTarget is false for _HOST42", () => {
  assert(!self.isInvalidFileToTarget("_HOST42"));
});

Deno.test("isInvalidFileToTarget is false for _platform", () => {
  assert(!self.isInvalidFileToTarget("_unknown"));
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

Deno.test("getDotLinks returns one file", async () => {
  const readDir = Deno.readDir;
  Deno.readDir = mock.makeMockReadDir([
    {
      name: "home",
      isDirectory: true,
      entries: [{ name: "man", isFile: true }],
    },
  ]);
  mockRegistry.resolve = (s: string) => `/resolved/to/${s}`;

  for await (const file of self.getDotLinks("home")) {
    assertEquals(
      { link: "/some/home/.home/man", target: "/resolved/to/home/man" },
      file
    );
  }

  delete mockRegistry.resolve;
  Deno.readDir = readDir;
});

Deno.test("getDotLinks returns more files", async () => {
  const readDir = Deno.readDir;
  Deno.readDir = mock.makeMockReadDir([
    {
      name: "home",
      isDirectory: true,
      entries: [
        { name: "man", isFile: true },
        { name: "macho", isFile: false, isDirectory: true },
      ],
    },
  ]);
  mockRegistry.resolve = (s: string) => `/resolved/to/${s}`;

  const results = [];
  for await (const file of self.getDotLinks("home")) {
    results.push(file);
  }

  assertEquals(
    [
      { link: "/some/home/.home/man", target: "/resolved/to/home/man" },
      { link: "/some/home/.home/macho", target: "/resolved/to/home/macho" },
    ],
    results
  );

  delete mockRegistry.resolve;
  Deno.readDir = readDir;
});

Deno.test("getDotLinks removes base", async () => {
  const readDir = Deno.readDir;
  Deno.readDir = mock.makeMockReadDir([
    {
      name: "home",
      isDirectory: true,
      entries: [{ name: "man", isFile: true }],
    },
  ]);
  mockRegistry.resolve = (s: string) => `/resolved/to/${s}`;

  for await (const file of self.getDotLinks("home", {
    nameRelativeToBase: true,
  })) {
    assertEquals(
      { link: "/some/home/.man", target: "/resolved/to/home/man" },
      file
    );
  }

  delete mockRegistry.resolve;
  Deno.readDir = readDir;
});

Deno.test({
  name: "getDotLinks recurses",
  async fn() {
    const readDir = Deno.readDir;
    Deno.readDir = mock.makeMockReadDir([
      {
        name: "home",
        isDirectory: true,
        entries: [
          {
            name: "macho",
            isFile: false,
            isDirectory: true,
            entries: [{ name: "man", isFile: true }],
          },
        ],
      },
    ]);
    mockRegistry.resolve = (s: string) => `/resolved/to/${s}`;

    const results = [];
    for await (const file of self.getDotLinks("home", { recurse: true })) {
      results.push(file);
    }

    assertEquals(
      [
        {
          link: "/some/home/.home/macho/man",
          target: "/resolved/to/home/macho/man",
        },
      ],
      results
    );

    delete mockRegistry.resolve;
    Deno.readDir = readDir;
  },
});

Deno.test({
  name: "getDotLinks recurses and removes base",
  async fn() {
    const readDir = Deno.readDir;
    Deno.readDir = mock.makeMockReadDir([
      {
        name: "home",
        isDirectory: true,
        entries: [
          {
            name: "macho",
            isFile: false,
            isDirectory: true,
            entries: [{ name: "man", isFile: true }],
          },
        ],
      },
    ]);
    mockRegistry.resolve = (s: string) => `/resolved/to/${s}`;

    const results = [];
    for await (const file of self.getDotLinks("home", {
      recurse: true,
      nameRelativeToBase: true,
    })) {
      results.push(file);
    }

    assertEquals(
      [
        {
          link: "/some/home/.macho/man",
          target: "/resolved/to/home/macho/man",
        },
      ],
      results
    );

    delete mockRegistry.resolve;
    Deno.readDir = readDir;
  },
});

Deno.test({
  name: "getDotLinks resolves symlink targets to their targets",
  async fn() {
    const readLink = Deno.readLink;
    Deno.readLink = async () => "some/linked/file";

    const readDir = Deno.readDir;
    Deno.readDir = mock.makeMockReadDir([
      {
        name: "home",
        isDirectory: true,
        entries: [
          {
            name: "macho",
            isFile: true,
            isSymlink: true,
          },
        ],
      },
    ]);
    mockRegistry.resolve = (s: string, t: string) => `/resolved/to/${s}/${t}`;

    const results = [];
    for await (const file of self.getDotLinks("home", {
      recurse: true,
    })) {
      results.push(file);
    }

    assertEquals(
      [
        {
          link: "/some/home/.home/macho",
          target: "/resolved/to/home/some/linked/file",
        },
      ],
      results
    );

    delete mockRegistry.resolve;
    Deno.readDir = readDir;
    Deno.readLink = readLink;
  },
});

Deno.test({
  name: "findDotLinks finds symlinks that start with REPO_LOCATION",
  async fn() {
    const readLink = Deno.readLink;
    Deno.readLink = async (link) =>
      link === "home/.macho" ? "/some/repo/home/linked" : "/other/location";

    const readDir = Deno.readDir;
    Deno.readDir = mock.makeMockReadDir([
      {
        name: "home",
        isDirectory: true,
        entries: [
          {
            name: ".macho",
            isFile: true,
            isSymlink: true,
          },
          {
            name: ".nacho",
            isFile: true,
            isSymlink: true,
          },
        ],
      },
    ]);
    mockRegistry.resolve = (s: string, t: string) => `/resolved/to/${s}/${t}`;

    const results = [];
    for await (const file of self.findDotLinks("home")) {
      results.push(file);
    }

    assertEquals(
      [
        {
          link: "home/.macho",
          target: "/some/repo/home/linked",
        },
      ],
      results
    );

    delete mockRegistry.resolve;
    Deno.readDir = readDir;
    Deno.readLink = readLink;
  },
});

Deno.test({
  name: "findDotLinks finds symlinks that match optional filter",
  async fn() {
    const readLink = Deno.readLink;
    Deno.readLink = async () => "/some/repo/home/linked";

    const readDir = Deno.readDir;
    Deno.readDir = mock.makeMockReadDir([
      {
        name: "home",
        isDirectory: true,
        entries: [
          {
            name: ".macho",
            isFile: true,
            isSymlink: true,
          },
          {
            name: ".nacho",
            isFile: true,
            isSymlink: true,
          },
        ],
      },
    ]);
    mockRegistry.resolve = (s: string, t: string) => `/resolved/to/${s}/${t}`;

    const results = [];
    for await (const file of self.findDotLinks("home", {
      filter: (v) => v.name.startsWith(".m"),
    })) {
      results.push(file);
    }

    assertEquals(
      [
        {
          link: "home/.macho",
          target: "/some/repo/home/linked",
        },
      ],
      results
    );

    delete mockRegistry.resolve;
    Deno.readDir = readDir;
    Deno.readLink = readLink;
  },
});

Deno.test({
  name: "findDotLinks finds symlinks recursively",
  async fn() {
    const readLink = Deno.readLink;
    Deno.readLink = async () => "/some/repo/home/linked";

    const readDir = Deno.readDir;
    Deno.readDir = mock.makeMockReadDir([
      {
        name: "home",
        isDirectory: true,
        entries: [
          {
            name: ".macho",
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
    mockRegistry.resolve = (s: string, t: string) => `/resolved/to/${s}/${t}`;

    const results = [];
    for await (const file of self.findDotLinks("home", { recursive: true })) {
      results.push(file);
    }

    assertEquals(
      [
        {
          link: "home/.macho/man",
          target: "/some/repo/home/linked",
        },
      ],
      results
    );

    delete mockRegistry.resolve;
    Deno.readDir = readDir;
    Deno.readLink = readLink;
  },
});
