cmd = vim.cmd
fn = vim.fn
g = vim.g
opt = vim.opt
map = vim.api.nvim_set_keymap
bufmap = vim.api.nvim_buf_set_keymap

noremapSilent = {noremap=true, silent=true}
noremap = {noremap=true}

require "user.my-options"
require "user.my-keymaps"
require "user.my-plugins"
require "user.my-autocmd"
