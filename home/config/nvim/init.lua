vim.g.mapleader = " "

local mong8se = require("mong8se")

mong8se.requireOrComplain("bootstrap", "base", "auto", "colors", "extended",
                          "keys")

mong8se.loadRCFiles()
