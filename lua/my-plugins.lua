local cmd = vim.cmd
local g = vim.g
local map = vim.api.nvim_set_keymap
local bufmap = vim.api.nvim_buf_set_keymap
local noremapSilent = {noremap=true, silent=true}
local noremap = {noremap=true}

cmd('packadd! bufselect') -- ############################ https://github.com/PhilRunninger/bufselect
g.BufSelectKeyDeleteBuffer='w'
g.BufSelectKeyOpen='l'
map('n', '<leader>b', ':ShowBufferList<CR>', noremapSilent)

cmd('packadd! crease.vim') -- ############################### https://github.com/scr1pt0r/crease.vim
g.crease_foldtext = {default='%{repeat("▶",v:foldlevel)}%{repeat(" ",v:foldlevel)}%t%=[%l lines]'}

cmd('packadd! csv.vim') -- ##################################### https://github.com/chrisbra/csv.vim
g.no_csv_maps = 1

cmd('packadd! vim-easy-align') -- ####################### https://github.com/junegunn/vim-easy-align
map('v', '<Enter>', '<Plug>(LiveEasyAlign)', {})

cmd('packadd! vim-fugitive') -- ############################## https://github.com/tpope/vim-fugitive
map('n', '<F3>', '"zyiw/<C-R>z<CR>:Ggrep -i -e \'<C-R>z\'<CR><CR>:copen<CR>:redraw!<CR>', noremapSilent)
map('v', '<F3>', '"zy/<C-R>z<CR>:Ggrep -i -e \'<C-R>z\'<CR><CR>:copen<CR>:redraw!<CR>', noremapSilent)
map('n', '<leader>G', ':Git<CR>', noremapSilent)

-- This plugin (tpope's) ships with Neovim. ############################################### MARKDOWN
g.markdown_folding = 1
g.markdown_fenced_languages = {'vim','sql','cs','ps1'}

cmd('packadd! vim-matchup') -- ############################# https://github.com/andymass/vim-matchup
g.matchup_matchparen_offscreen = {method='popup'}

cmd('packadd! presenting.vim') -- ########################## https://github.com/sotte/presenting.vim
g.presenting_quit = '<Esc>'
g.presenting_next = '<Right>'
g.presenting_prev = '<Left>'

cmd('packadd! vim-rest-console') -- ###################### https://github.com/diepm/vim-rest-console
g.vrc_show_command = 1
g.vrc_trigger = '<F5>'

cmd('packadd! vifm.vim') -- ######################################  https://github.com/vifm/vifm.vim
-- vifm/vifm.vim.rc sets up mappings s, v, T, and q for quicker file picker operations.
-- $VIFM is a vifm-internal variable that points to ~/AppData/Roaming/Vifm or ~/.config/vifm.
g.vifm_exec_args = '-c "source $VIFM/vifm.vim.rc"'
map('n', '<leader>o', ':Vifm<CR>', noremapSilent)

cmd('packadd! undotree') -- ##################################### https://github.com/mbbill/undotree
map('n', '<leader>u', ':UndotreeShow<CR>', noremapSilent)
g.undotree_WindowLayout = 2
g.undotree_HelpLine = 0
g.undotree_ShortIndicators = 1
g.undotree_TreeNodeShape = '●'
g.undotree_TreeVertShape = '│'
g.undotree_TreeSplitShape = '╱'
g.undotree_TreeReturnShape = '╲'
g.undotree_SetFocusWhenToggle = 1

cmd('packadd! unicode.vim') -- ############################# https://github.com/chrisbra/unicode.vim
map('n', 'ga', ':UnicodeName<CR>', noremapSilent)
map('n', '<leader>ga', ':UnicodeSearch!<space>', noremap)

-- ######################################################################################## SNIPPETS
cmd('packadd! LuaSnip') --                                       https://github.com/L3MON4D3/LuaSnip
cmd('packadd! friendly-snippets') --                 https://github.com/rafamadriz/friendly-snippets

-- ###################################################################################### COMPLETION
cmd('packadd! nvim-cmp') --                                      https://github.com/hrsh7th/nvim-cmp
cmd('packadd! cmp-buffer') --                                  https://github.com/hrsh7th/cmp-buffer
cmd('packadd! cmp-path') --                                      https://github.com/hrsh7th/cmp-path
cmd('packadd! cmp_luasnip') --                           https://github.com/saadparwaiz1/cmp_luasnip
cmd('packadd! cmp-nvim-lsp') --                              https://github.com/hrsh7th/cmp-nvim-lsp
cmd('packadd! cmp-nvim-lua') --                              https://github.com/hrsh7th/cmp-nvim-lua
cmd('packadd! cmp-rpncalc') --                          https://github.com/PhilRunninger/cmp-rpncalc
require "my-cmp"

-- ######################################################################## LANGUAGE SERVER PROTOCOL
cmd('packadd! mason.nvim') --                             https://github.com:williamboman/mason.nvim
cmd('packadd! mason-lspconfig.nvim') --         https://github.com:williamboman/mason-lspconfig.nvim
cmd('packadd! nvim-lspconfig') --                           https://github.com/neovim/nvim-lspconfig
require "my-lsp"

cmd('packadd! nvim-treesitter') -- ############## https://github.com/nvim-treesitter/nvim-treesitter
require "nvim-treesitter.configs".setup {
  ensure_installed = {"bash", "c_sharp", "css", "erlang", "graphql", "help", "html", "javascript", "json", "lua", "make", "markdown", "python", "regex", "ruby", "typescript", "vim", "yaml"},
  sync_install = false,
  ignore_install = {}, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {}, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,
  },
  indent = {enable = true, disable = {"yaml"}},
}

cmd('packadd! Comment.nvim') -- ########################### https://github.com/numToStr/Comment.nvim
require "Comment".setup()

cmd('packadd! gitsigns.nvim') -- ######################## https://github.com/lewis6991/gitsigns.nvim
require "gitsigns".setup {
    signs = {
        add = { hl = 'GitSignsAdd', text = '▊', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
        change = { hl = 'GitSignsChange', text = '▌', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
        delete = { hl = 'GitSignsDelete', text = '▎', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        topdelete = { hl = 'GitSignsDelete', text = '▎', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        changedelete = { hl = 'GitSignsChange', text = '▌', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    },
    on_attach = function (bufnr)
        bufmap(bufnr, 'n', ']c', ':Gitsigns next_hunk<CR>', noremapSilent)
        bufmap(bufnr, 'n', '[c', ':Gitsigns prev_hunk<CR>', noremapSilent)
        bufmap(bufnr, 'n', '<leader>hp', ':Gitsigns preview_hunk<CR>', noremapSilent)
    end,
}

cmd('packadd! nvim-colorizer.lua') -- ################# https://github.com/NvChad/nvim-colorizer.lua
require 'colorizer'.setup()

cmd('packadd! neovim-ayu') -- ################################# https://github.com/Shatur/neovim-ayu
require 'ayu'.setup({
    overrides = function()
        local colors = require('ayu.colors')
        return
        { -- Override builtin colors, for better contrast.
            VertSplit    = {bg = 'NONE', fg = colors.normal},
            SignColumn   = {bg = 'NONE'},
            LineNr       = {fg = colors.comment},
            CursorLine   = {bg = colors.gutter_normal},
            CursorColumn = {bg = colors.gutter_normal},
            ColorColumn  = {bg = colors.gutter_normal},
            Visual       = {bg = colors.guide_active},
            NormalNC     = {bg = colors.selection_inactive},
            SpecialKey   = {fg = '#ff00af'},
            MatchParen   = {bg = '#af00af', fg = '#ffcf00', underline = false},
            TabLineSel        = {bg = colors.accent, fg = colors.black, underline = false, bold = true, italic = true},
            TabLine           = {underline = true},
            TabLineFill       = {underline = true}
        }
    end
})
require 'ayu'.colorscheme()

-- ###################################################################################### ALL OTHERS
cmd('packadd! markdown-preview.nvim') --             https://github.com/iamcco/markdown-preview.nvim
cmd('packadd! Recover.vim') --                               https://github.com:chrisbra/Recover.vim
cmd('packadd! vim-exchange') --                              https://github.com/tommcdo/vim-exchange
cmd('packadd! vim-repeat') --                                    https://github.com/tpope/vim-repeat
cmd('packadd! vim-sessions') --                        https://github.com/PhilRunninger/vim-sessions
cmd('packadd! vim-signature') --                            https://github.com/kshenoy/vim-signature
cmd('packadd! vim-surround') --                                https://github.com/tpope/vim-surround
cmd('packadd! vim-unimpaired') --                            https://github.com/tpope/vim-unimpaired

-- Must come AFTER the :packadd! calls above; otherwise, the contents of
-- package 'ftdetect' directories won't be evaluated.
cmd('filetype indent plugin on')
