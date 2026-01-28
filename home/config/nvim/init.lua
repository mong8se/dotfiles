vim.g.mapleader = " "
vim.g.maplocalleader = ","

local mong8se = require("mong8se")

mong8se.require_or_complain("bootstrap", "base", "auto", "colors", "keys")

mong8se.load_rc_files()
