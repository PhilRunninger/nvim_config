Cmd('packadd! bufselect.vim') -- ######################################################### BUFSELECT
G.BufSelectKeyDeleteBuffer='w'
G.BufSelectKeyOpen='l'
Map('n', '<leader>b', '<Cmd>ShowBufferList<CR>', NoremapSilent)

Cmd('packadd! crease.vim') -- ############################################################### CREASE
G.crease_foldtext = {default='%{repeat(">",v:foldlevel)}%{repeat(" ",v:foldlevel)}%t%=[%l lines]'}

Cmd('packadd! csv.vim') -- ##################################################################### CSV
G.no_csv_maps = 1

Cmd('packadd! vim-easy-align') -- ######################################################## EASYALIGN
Map('v', '<Enter>', '<Plug>(LiveEasyAlign)', Noremap)

Cmd('packadd! vim-fugitive') -- ########################################################### FUGITIVE
Map('n', '<F3>', '"zyiw/<C-R>z<CR>:Ggrep -i -e \'<C-R>z\'<CR><CR>:copen<CR>:redraw!<CR>', NoremapSilent)
Map('v', '<F3>', '"zy/<C-R>z<CR>:Ggrep -i -e \'<C-R>z\'<CR><CR>:copen<CR>:redraw!<CR>', NoremapSilent)
Map('n', '<leader>G', '<Cmd>Git<CR>', NoremapSilent)

-- This plugin (tpope's) ships with Neovim. ############################################### MARKDOWN
G.markdown_folding = 1
G.markdown_fenced_languages = {'vim','sql','cs','ps1'}

Cmd('packadd! vim-matchup') -- ############################################################# MATCHUP
G.matchup_matchparen_offscreen = {method='popup'}

Cmd('packadd! mintree') -- ################################################################# MINTREE
G.MinTreeExpanded='▼'
G.MinTreeCollapsed='▶'
G.MinTreeOpen='l'
G.MinTreeCloseParent='h'
G.MinTreeOpenTab='T'
G.MinTreeTagAFile='t'
Map('n', '<leader>o', '<Cmd>MinTree<CR>', NoremapSilent)
Map('n', '<leader>f', '<Cmd>MinTreeFind<CR>', NoremapSilent)

Cmd('packadd! presenting.vim') -- ####################################################### PRESENTING
G.presenting_quit = '<Esc>'
G.presenting_next = '<Right>'
G.presenting_prev = '<Left>'

Cmd('packadd! vim-rest-console') -- ################################################### REST CONSOLE
G.vrc_show_command = 1
G.vrc_trigger = '<leader>r'

Cmd('packadd! undotree') -- ############################################################### UNDOTREE
Map('n', '<leader>u', '<Cmd>UndotreeToggle<CR>', NoremapSilent)
G.undotree_WindowLayout = 2
G.undotree_HelpLine = 0
G.undotree_ShortIndicators = 1

Cmd('packadd! unicode.vim') -- ############################################################# UNICODE
Map('n', 'ga', '<Cmd>UnicodeName<CR>', NoremapSilent)
Map('n', '<leader>k', ':UnicodeSearch!<space>', Noremap)

Cmd('packadd! LuaSnip') -- ################################################################ SNIPPETS
Cmd('packadd! friendly-snippets')

Cmd('packadd! nvim-cmp') -- ############################################################# COMPLETION
Cmd('packadd! cmp-buffer')
Cmd('packadd! cmp-path')
Cmd('packadd! cmp_luasnip')
Cmd('packadd! cmp-nvim-lsp')
Cmd('packadd! cmp-nvim-lua')
require "user.my-cmp"

Cmd('packadd! nvim-lspconfig') -- ############################################################## LSP
Cmd('packadd! nvim-lsp-installer')
require "user.my-lsp"

Cmd('packadd! plenary.nvim') -- ########################################################## TELESCOPE
Cmd('packadd! telescope.nvim')
require "user.my-telescope"

Cmd('packadd! nvim-treesitter') -- ###################################################### TREESITTER
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

Cmd('packadd! Comment.nvim') -- ############################################################ COMMENT
require "Comment".setup()

Cmd('packadd! gitsigns.nvim') -- ########################################################## GITSIGNS
require "gitsigns".setup {
    signs = {
        add = { hl = 'GitSignsAdd', text = '▊', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
        change = { hl = 'GitSignsChange', text = '▌', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
        delete = { hl = 'GitSignsDelete', text = '▎', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        topdelete = { hl = 'GitSignsDelete', text = '▎', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        changedelete = { hl = 'GitSignsChange', text = '▌', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    },
    on_attach = function (bufnr)
        Bufmap(bufnr, 'n', ']c', '<CMD>Gitsigns next_hunk<CR>', NoremapSilent)
        Bufmap(bufnr, 'n', '[c', '<CMD>Gitsigns prev_hunk<CR>', NoremapSilent)
        Bufmap(bufnr, 'n', '<leader>hp', '<CMD>Gitsigns preview_hunk<CR>', NoremapSilent)
    end,
}

Cmd('packadd! nvim-colorizer.lua') -- ############################################### NVIM-COLORIZER
require 'colorizer'.setup()

-- ###################################################################################### ALL OTHERS
Cmd('packadd! ldraw.vim')
Cmd('packadd! papercolor-theme')
Cmd('packadd! vim-exchange')
Cmd('packadd! vim-repeat')
Cmd('packadd! vim-sessions')
Cmd('packadd! vim-signature')
Cmd('packadd! vim-surround')
Cmd('packadd! vim-unimpaired')

-- Must come AFTER the :packadd! calls above; otherwise, the contents of
-- package 'ftdetect' directories won't be evaluated.
Cmd('filetype indent plugin on')
