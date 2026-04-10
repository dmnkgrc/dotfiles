vim.loader.enable()

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = true

require("config.options")
require("config.keymaps")
require("config.autocmds")

local pack = require("config.pack")
pack.register_hooks()
pack.add_all()

require("plugins.init").load()

-- vim: ts=2 sts=2 sw=2 et
