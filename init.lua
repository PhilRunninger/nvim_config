-- vim:foldmethod=marker

local private_rtp = vim.fn.stdpath('config') .. '/private'
if vim.fn.isdirectory(private_rtp) then
    vim.opt.runtimepath:prepend(private_rtp)
end

if vim.g.vscode then
    -- Use the lua/code directory for VSCode specific settings.
    -- Example: require "code.options"

else
    require "neovim.options"
    require "neovim.keymaps"
    require "neovim.deps"
    require "neovim.autocmd"
    require "neovim.statusline"
    require "neovim.tabline"
    require "neovim.floatterminal"
    require "search"

    MiniDeps.later(function()
        vim.cmd('colorscheme tango')
        vim.notify('Ready.',vim.log.levels.WARN)
    end)
end
