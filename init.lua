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

    vim.cmd('colorscheme tango')
end
