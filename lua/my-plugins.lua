local cmd = vim.cmd
local g = vim.g
local map = vim.api.nvim_set_keymap
local bufmap = vim.api.nvim_buf_set_keymap
local noremapSilent = {noremap=true, silent=true}
local noremap = {noremap=true}

cmd('packadd! bufselect.vim') -- #################### https://github.com/PhilRunninger/bufselect.vim
g.BufSelectKeyDeleteBuffer='w'
g.BufSelectKeyOpen='l'
map('n', '<leader>b', '<Cmd>ShowBufferList<CR>', noremapSilent)

cmd('packadd! crease.vim') -- ############################### https://github.com/scr1pt0r/crease.vim
g.crease_foldtext = {default='%{repeat(">",v:foldlevel)}%{repeat(" ",v:foldlevel)}%t%=[%l lines]'}

cmd('packadd! csv.vim') -- ##################################### https://github.com/chrisbra/csv.vim
g.no_csv_maps = 1

cmd('packadd! vim-easy-align') -- ####################### https://github.com/junegunn/vim-easy-align
map('v', '<Enter>', '<Plug>(LiveEasyAlign)', {})

cmd('packadd! vim-fugitive') -- ############################## https://github.com/tpope/vim-fugitive
map('n', '<F3>', '"zyiw/<C-R>z<CR>:Ggrep -i -e \'<C-R>z\'<CR><CR>:copen<CR>:redraw!<CR>', noremapSilent)
map('v', '<F3>', '"zy/<C-R>z<CR>:Ggrep -i -e \'<C-R>z\'<CR><CR>:copen<CR>:redraw!<CR>', noremapSilent)
map('n', '<leader>G', '<Cmd>Git<CR>', noremapSilent)

-- This plugin (tpope's) ships with Neovim. ############################################### MARKDOWN
g.markdown_folding = 1
g.markdown_fenced_languages = {'vim','sql','cs','ps1'}

cmd('packadd! vim-matchup') -- ############################# https://github.com/andymass/vim-matchup
g.matchup_matchparen_offscreen = {method='popup'}

cmd('packadd! mintree') -- ################################ https://github.com/PhilRunninger/mintree
g.MinTreeExpanded='◢'
g.MinTreeCollapsed='▷'
g.MinTreeOpen='l'
g.MinTreeCloseParent='h'
g.MinTreeOpenTab='T'
g.MinTreeTagAFile='t'
map('n', '<leader>o', '<Cmd>MinTree<CR>', noremapSilent)
map('n', '<leader>f', '<Cmd>MinTreeFind<CR>', noremapSilent)

cmd('packadd! presenting.vim') -- ########################## https://github.com/sotte/presenting.vim
g.presenting_quit = '<Esc>'
g.presenting_next = '<Right>'
g.presenting_prev = '<Left>'

cmd('packadd! vim-rest-console') -- ###################### https://github.com/diepm/vim-rest-console
g.vrc_show_command = 1
g.vrc_trigger = '<F5>'

cmd('packadd! undotree') -- ##################################### https://github.com/mbbill/undotree
map('n', '<leader>u', '<Cmd>UndotreeShow<CR>', noremapSilent)
g.undotree_WindowLayout = 2
g.undotree_HelpLine = 0
g.undotree_ShortIndicators = 1
g.undotree_TreeNodeShape = '●'
g.undotree_TreeVertShape = '│'
g.undotree_TreeSplitShape = '╱'
g.undotree_TreeReturnShape = '╲'
g.undotree_SetFocusWhenToggle = 1

cmd('packadd! unicode.vim') -- ############################# https://github.com/chrisbra/unicode.vim
map('n', 'ga', '<Cmd>UnicodeName<CR>', noremapSilent)
map('n', '<leader>k', ':UnicodeSearch!<space>', noremap)

cmd('packadd! LuaSnip') -- ##################################### https://github.com/L3MON4D3/LuaSnip
cmd('packadd! friendly-snippets') --                 https://github.com/rafamadriz/friendly-snippets

cmd('packadd! nvim-cmp') -- #################################### https://github.com/hrsh7th/nvim-cmp
cmd('packadd! cmp-buffer') --                                  https://github.com/hrsh7th/cmp-buffer
cmd('packadd! cmp-path') --                                      https://github.com/hrsh7th/cmp-path
cmd('packadd! cmp_luasnip') --                           https://github.com/saadparwaiz1/cmp_luasnip
cmd('packadd! cmp-nvim-lsp') --                              https://github.com/hrsh7th/cmp-nvim-lsp
cmd('packadd! cmp-nvim-lua') --                              https://github.com/hrsh7th/cmp-nvim-lua
require "my-cmp"

cmd('packadd! nvim-lspconfig') -- ######################### https://github.com/neovim/nvim-lspconfig
cmd('packadd! nvim-lsp-installer') --             https://github.com/williamboman/nvim-lsp-installer
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
        bufmap(bufnr, 'n', ']c', '<CMD>Gitsigns next_hunk<CR>', noremapSilent)
        bufmap(bufnr, 'n', '[c', '<CMD>Gitsigns prev_hunk<CR>', noremapSilent)
        bufmap(bufnr, 'n', '<leader>hp', '<CMD>Gitsigns preview_hunk<CR>', noremapSilent)
    end,
}


cmd('packadd! nvim-colorizer.lua') -- ############### https://github.com/norcalli/nvim-colorizer.lua
require 'colorizer'.setup()

cmd('packadd! neovim-ayu') -- ################################# https://github.com/Shatur/neovim-ayu
require 'ayu'.setup({
    overrides = function()
        return vim.tbl_extend('force',
          { -- My custom highlight groups for the statusline.
            GitBranch    = {bg = '#f54d27', fg = '#efefe7'},
            Session      = {bg = '#ffaf00', fg = '#000000'},
            SLTerm       = {bg = '#ffaf00', fg = '#000000'},
            SLInsert     = {bg = '#005fff', fg = '#ffffff'},
            SLNormalMod  = {bg = '#af0000', fg = '#ffffff'},
            SLNormal     = {bg = '#00df00', fg = '#000000'},
            -- Override builtin colors
            WinSeparator = {bg = 'NONE'},
            LineNr       = {fg = '#90a4c9'},
            Search       = {bg = '#0080c0', fg = '#ffffff'}, },
          vim.o.background == 'dark' and
          { Visual       = {bg = '#404040'},
            CursorLine   = {bg = '#31334b'},
            CursorColumn = {bg = '#31334b'},
            ColorColumn  = {bg = '#31334b'},
            NormalNC     = {bg = '#0f151e', fg = '#808080'}, }
          or
          { Visual       = {bg = '#c0c0c0'},
            CursorLine   = {bg = '#e0e0e0'},
            CursorColumn = {bg = '#e0e0e0'},
            ColorColumn  = {bg = '#e0e0e0'},
            NormalNC     = {bg = '#f0f0f0', fg = '#808080'}, }
        )
      end
})
require 'ayu'.colorscheme()

-- ###################################################################################### ALL OTHERS
cmd('packadd! ldraw.vim') --                                https://github.com/vim-scripts/ldraw.vim
cmd('packadd! vim-exchange') --                              https://github.com/tommcdo/vim-exchange
cmd('packadd! vim-repeat') --                                    https://github.com/tpope/vim-repeat
cmd('packadd! vim-sessions') --                        https://github.com/PhilRunninger/vim-sessions
cmd('packadd! vim-signature') --                            https://github.com/kshenoy/vim-signature
cmd('packadd! vim-surround') --                                https://github.com/tpope/vim-surround
cmd('packadd! vim-unimpaired') --                            https://github.com/tpope/vim-unimpaired

-- Must come AFTER the :packadd! calls above; otherwise, the contents of
-- package 'ftdetect' directories won't be evaluated.
cmd('filetype indent plugin on')
