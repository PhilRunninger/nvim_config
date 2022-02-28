local cmd = vim.cmd
local g = vim.g
local map = vim.api.nvim_set_keymap
local bufmap = vim.api.nvim_buf_set_keymap
local noremapSilent = {noremap=true, silent=true}
local noremap = {noremap=true}

cmd('packadd! bufselect.vim') -- ######################################################### BUFSELECT
g.BufSelectKeyDeleteBuffer='w'
g.BufSelectKeyOpen='l'
map('n', '<leader>b', '<Cmd>ShowBufferList<CR>', noremapSilent)

cmd('packadd! crease.vim') -- ############################################################### CREASE
g.crease_foldtext = {default='%{repeat(">",v:foldlevel)}%{repeat(" ",v:foldlevel)}%t%=[%l lines]'}

cmd('packadd! csv.vim') -- ##################################################################### CSV
g.no_csv_maps = 1

cmd('packadd! vim-easy-align') -- ######################################################## EASYALIGN
map('v', '<Enter>', '<Plug>(LiveEasyAlign)', {})

cmd('packadd! vim-fugitive') -- ########################################################### FUGITIVE
map('n', '<F3>', '"zyiw/<C-R>z<CR>:Ggrep -i -e \'<C-R>z\'<CR><CR>:copen<CR>:redraw!<CR>', noremapSilent)
map('v', '<F3>', '"zy/<C-R>z<CR>:Ggrep -i -e \'<C-R>z\'<CR><CR>:copen<CR>:redraw!<CR>', noremapSilent)
map('n', '<leader>G', '<Cmd>Git<CR>', noremapSilent)

-- This plugin (tpope's) ships with Neovim. ############################################### MARKDOWN
g.markdown_folding = 1
g.markdown_fenced_languages = {'vim','sql','cs','ps1'}

cmd('packadd! vim-matchup') -- ############################################################# MATCHUP
g.matchup_matchparen_offscreen = {method='popup'}

cmd('packadd! mintree') -- ################################################################# MINTREE
g.MinTreeExpanded='▼'
g.MinTreeCollapsed='▶'
g.MinTreeOpen='l'
g.MinTreeCloseParent='h'
g.MinTreeOpenTab='T'
g.MinTreeTagAFile='t'
map('n', '<leader>o', '<Cmd>MinTree<CR>', noremapSilent)
map('n', '<leader>f', '<Cmd>MinTreeFind<CR>', noremapSilent)

cmd('packadd! presenting.vim') -- ####################################################### PRESENTING
g.presenting_quit = '<Esc>'
g.presenting_next = '<Right>'
g.presenting_prev = '<Left>'

cmd('packadd! vim-rest-console') -- ################################################### REST CONSOLE
g.vrc_show_command = 1
g.vrc_trigger = '<leader>r'

cmd('packadd! undotree') -- ############################################################### UNDOTREE
map('n', '<leader>u', '<Cmd>UndotreeShow<CR>', noremapSilent)
g.undotree_WindowLayout = 2
g.undotree_HelpLine = 0
g.undotree_ShortIndicators = 1
g.undotree_TreeNodeShape = '●'
g.undotree_TreeVertShape = '│'
g.undotree_TreeSplitShape = '╱'
g.undotree_TreeReturnShape = '╲'
g.undotree_SetFocusWhenToggle = 1

cmd('packadd! unicode.vim') -- ############################################################# UNICODE
map('n', 'ga', '<Cmd>UnicodeName<CR>', noremapSilent)
map('n', '<leader>k', ':UnicodeSearch!<space>', noremap)

cmd('packadd! LuaSnip') -- ################################################################ SNIPPETS
cmd('packadd! friendly-snippets')

cmd('packadd! nvim-cmp') -- ############################################################# COMPLETION
cmd('packadd! cmp-buffer')
cmd('packadd! cmp-path')
cmd('packadd! cmp_luasnip')
cmd('packadd! cmp-nvim-lsp')
cmd('packadd! cmp-nvim-lua')
require "my-cmp"

cmd('packadd! nvim-lspconfig') -- ############################################################## LSP
cmd('packadd! nvim-lsp-installer')
require "my-lsp"

cmd('packadd! plenary.nvim') -- ########################################################## TELESCOPE
cmd('packadd! telescope.nvim')
require "my-telescope"

cmd('packadd! nvim-treesitter') -- ###################################################### TREESITTER
require "nvim-treesitter.configs".setup {
  ensure_installed = "maintained",
  sync_install = false,
  ignore_install = { "" }, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true, disable = { "yaml" } },
}

cmd('packadd! Comment.nvim') -- ############################################################ COMMENT
require "Comment".setup()

cmd('packadd! gitsigns.nvim') -- ########################################################## GITSIGNS
require "gitsigns".setup {
    signs = {
        add = { hl = 'GitSignsAdd', text = '▊', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
        change = { hl = 'GitSignsChange', text = '▌', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
        delete = { hl = 'GitSignsDelete', text = '▎', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        topdelete = { hl = 'GitSignsDelete', text = '▎', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        changedelete = { hl = 'GitSignsChange', text = '▌', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    },
    on_attach = function (bufnr)
        bufmap(bufnr, 'n', ']c', '<CMD>Gitsigns next_hunk<CR>', noremapSilent)
        bufmap(bufnr, 'n', '[c', '<CMD>Gitsigns prev_hunk<CR>', noremapSilent)
        bufmap(bufnr, 'n', '<leader>hp', '<CMD>Gitsigns preview_hunk<CR>', noremapSilent)
    end,
}

cmd('packadd! nvim-colorizer.lua') -- ############################################### NVIM-COLORIZER
require 'colorizer'.setup()

cmd('packadd! neovim-ayu') -- ####################################################### NVIM-COLORIZER
require 'ayu'.setup({})

-- ###################################################################################### ALL OTHERS
cmd('packadd! ldraw.vim')
-- cmd('packadd! papercolor-theme')
cmd('packadd! vim-exchange')
cmd('packadd! vim-repeat')
cmd('packadd! vim-sessions')
cmd('packadd! vim-signature')
cmd('packadd! vim-surround')
cmd('packadd! vim-unimpaired')

-- Must come AFTER the :packadd! calls above; otherwise, the contents of
-- package 'ftdetect' directories won't be evaluated.
cmd('filetype indent plugin on')
