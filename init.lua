-- vim:foldmethod=marker

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
        vim.notify('You\'re ready to go.')
    end)
end
