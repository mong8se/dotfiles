vim.g.mapleader = " "

local mong8se = require("mong8se")

mong8se.requireOrComplain("lazy-init")
mong8se.requireOrComplain("base")
mong8se.requireOrComplain("auto")
mong8se.requireOrComplain("colors")
mong8se.requireOrComplain("extended")
mong8se.requireOrComplain("keys")

mong8se.loadRCFiles()
