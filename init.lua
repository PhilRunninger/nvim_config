-- Disable netrw.
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

if vim.g.vscode then
    require "vscode"
else
    require "nvim"

    vim.cmd('colorscheme tango')
    -- Lower the priority of semantic tokens to stop the mangled highlighting.
    vim.highlight.priorities.semantic_tokens = 75
end
