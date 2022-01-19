-- BUFSELECT #####################################################################
cmd('packadd! bufselect.vim')
g.BufSelectKeyDeleteBuffer='w'
g.BufSelectKeyOpen='l'
map('n', '<leader>b', '<Cmd>ShowBufferList<CR>', noremapSilent)

-- CREASE ########################################################################
cmd('packadd! crease.vim')
g.crease_foldtext = {default='%{repeat(">",v:foldlevel)}%{repeat(" ",v:foldlevel)}%t %{gitgutter#fold#is_changed()?"⭐":""} %=[%l lines]'}

-- CSV ###########################################################################
cmd('packadd! csv.vim')
g.no_csv_maps = 1

-- EASYALIGN #####################################################################
cmd('packadd! vim-easy-align')
map('v', '<Enter>', '<Plug>(LiveEasyAlign)', noremapSilent)

-- FUGITIVE ######################################################################
cmd('packadd! vim-fugitive')
map('n', '<F3>', '"zyiw/<C-R>z<CR>:Ggrep -i -e \'<C-R>z\'<CR><CR>:copen<CR>:redraw!<CR>', noremapSilent)
map('v', '<F3>', '"zy/<C-R>z<CR>:Ggrep -i -e \'<C-R>z\'<CR><CR>:copen<CR>:redraw!<CR>', noremapSilent)
map('n', '<leader>G', '<Cmd>Git<CR>', noremapSilent)

-- MARKDOWN ######################################################################
g.markdown_folding = 1
g.markdown_fenced_languages = {'vim','sql','cs','ps1'}

-- MATCHUP #######################################################################
cmd('packadd! vim-matchup')
g.matchup_matchparen_offscreen = {method='popup'}

-- MINTREE #######################################################################
cmd('packadd! mintree')
g.MinTreeExpanded='▼'
g.MinTreeCollapsed='▶'
g.MinTreeOpen='l'
g.MinTreeCloseParent='h'
g.MinTreeOpenTab='T'
g.MinTreeTagAFile='t'
map('n', '<leader>o', '<Cmd>MinTree<CR>', noremapSilent)
map('n', '<leader>f', '<Cmd>MinTreeFind<CR>', noremapSilent)

-- PRESENTING ####################################################################
cmd('packadd! presenting.vim')
g.presenting_quit = '<Esc>'
g.presenting_next = '<Right>'
g.presenting_prev = '<Left>'

-- REST CONSOLE ##################################################################
cmd('packadd! vim-rest-console')
g.vrc_show_command = 1
g.vrc_trigger = '<leader>r'

-- UNDOTREE ######################################################################
cmd('packadd! undotree')
map('n', '<leader>u', '<Cmd>UndotreeToggle<CR>', noremapSilent)
g.undotree_WindowLayout = 2
g.undotree_HelpLine = 0
g.undotree_ShortIndicators = 1

-- UNICODE #######################################################################
cmd('packadd! unicode.vim')
map('n', 'ga', '<Cmd>UnicodeName<CR>', noremapSilent)
map('n', '<leader>k', ':UnicodeSearch!<space>', noremapSilent)

-- COMPLETION ####################################################################
cmd('packadd! nvim-cmp')
cmd('packadd! cmp-buffer')
cmd('packadd! cmp-path')
cmd('packadd! cmp_luasnip')
cmd('packadd! cmp-nvim-lsp')
cmd('packadd! cmp-nvim-lua')

-- SNIPPETS ######################################################################
cmd('packadd! LuaSnip')
cmd('packadd! friendly-snippets')

-- LSP ###########################################################################
cmd('packadd! nvim-lspconfig')
cmd('packadd! nvim-lsp-installer')

-- ALL OTHERS ####################################################################
cmd('packadd! ldraw.vim')
cmd('packadd! papercolor-theme')
cmd('packadd! vim-commentary')
cmd('packadd! vim-exchange')
cmd('packadd! vim-gitgutter')
cmd('packadd! vim-repeat')
cmd('packadd! vim-sessions')
cmd('packadd! vim-signature')
cmd('packadd! vim-surround')
cmd('packadd! vim-unimpaired')

-- Must come AFTER the :packadd! calls above; otherwise, the contents of package 'ftdetect'
-- directories won't be evaluated.
cmd('filetype indent plugin on')
