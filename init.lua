-- vim:foldmethod=marker

local private_rtp = vim.fn.stdpath('config') .. '/private'
if vim.fn.isdirectory(private_rtp) then
    vim.opt.runtimepath:prepend(private_rtp)
end

require "options"
require "keymaps"
require "packager"
require "autocmd"
require "statusline"
require "tabline"
require "floatterminal"
require "search"

if not vim.g.vscode then
    vim.cmd.colorscheme('tango')
end
