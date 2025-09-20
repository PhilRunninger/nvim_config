if vim.g.vscode then
    -- Use the lua/code directory for VSCode specific settings.
    -- Example: require "code.options"

else
    vim.cmd('colorscheme tango')

    require "neovim.options"
    require "neovim.keymaps"
    require "neovim.deps"
    require "neovim.autocmd"
    require "neovim.statusline"
    require "neovim.tabline"
    require "neovim.floaterminal"
    require "search"
end
