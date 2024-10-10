-- Disable netrw.
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

require "my-options"
require "my-keymaps"
require "my-plugins"
require "my-autocmd"
require "my-statusline"
require "my-tabline"

vim.cmd('colorscheme strongbox')
-- Lower the priority of semantic tokens to stop the mangled highlighting.
vim.highlight.priorities.semantic_tokens = 75
