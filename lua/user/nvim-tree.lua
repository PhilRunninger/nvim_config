-- following options are the default
-- each of these are documented in `:help nvim-tree.OPTION_NAME`
g.nvim_tree_icons = {
  default = "",
  symlink = "",
  git = {
    unstaged = "",
    staged = "S",
    unmerged = "",
    renamed = "➜",
    deleted = "",
    untracked = "U",
    ignored = "◌",
  },
  folder = {
    default = "",
    open = "",
    empty = "",
    empty_open = "",
    symlink = "",
  },
}

g.nvim_tree_quit_on_open = 1
g.nvim_tree_highlight_opened_files = 1

local nvim_tree = require("nvim-tree")
local nvim_tree_config = require("nvim-tree.config")
local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup {
  auto_close = true,
  hijack_cursor = true,
  diagnostics = {
    enable = true,
  },
  view = {
    mappings = {
      list = {
        { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
        { key = "h", cb = tree_cb "close_node" },
        { key = "v", cb = tree_cb "vsplit" },
        { key = "s", cb = tree_cb "split" },
        { key = "t", cb = tree_cb "tabnew" },
        { key = "<C-s>", cb = tree_cb "system open" },
      },
    },
  },
}
