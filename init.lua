-- Global references to commonly used Vim API
Cmd = vim.cmd
Fn = vim.fn
G = vim.g
Opt = vim.opt
Map = vim.api.nvim_set_keymap
Bufmap = vim.api.nvim_buf_set_keymap

NoremapSilent = {noremap=true, silent=true}
Noremap = {noremap=true}

-- Split the rest of the setup into separate files.
require "my-options"
require "my-keymaps"
require "my-plugins"
require "my-autocmd"
