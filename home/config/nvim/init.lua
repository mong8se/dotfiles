vim.g.mapleader = " "
vim.g.maplocalleader = ","

local mong8se = require("mong8se")

mong8se.requireOrComplain("bootstrap", "base", "auto", "colors", "keys")

mong8se.loadRCFiles()
