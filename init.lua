local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local opt = vim.opt
local map = vim.api.nvim_set_keymap

-- Plugin Management (Comment a line to temporarily disable a plugin.)  {{{1
-- File / Buffer Management
cmd('packadd! mintree')
cmd('packadd! bufselect.vim')
-- Coding / Development
--cmd('packadd! coc.nvim')
cmd('packadd! vim-fugitive')
cmd('packadd! vim-gitgutter')
cmd('packadd! vim-commentary')
cmd('packadd! vim-rest-console')
cmd('packadd! vim-matchup')
-- Colorschemes
cmd('packadd! papercolor-theme')
-- Miscellaneous Utilities
cmd('packadd! ldraw.vim')
cmd('packadd! csv.vim')
cmd('packadd! crease.vim')
cmd('packadd! undotree')
cmd('packadd! vim-easy-align')
cmd('packadd! vim-sessions')
cmd('packadd! vim-signature')
cmd('packadd! vim-repeat')
cmd('packadd! vim-surround')
cmd('packadd! vim-unimpaired')
cmd('packadd! vim-exchange')
cmd('packadd! unicode.vim')
cmd('packadd! presenting.vim')

-- Must come AFTER the :packadd! calls above; otherwise, the contents of package 'ftdetect'
-- directories won't be evaluated.
cmd('filetype indent plugin on')
-- 
-- Function to ensure all my CoC extensions are installed.
-- function! InstallCocExtensions()
--     let installed = map(CocAction('extensionStats'), {_,v -> v.id})
--     for ext in ['coc-vimlsp', 'coc-omnisharp', 'coc-angular', 'coc-erlang_ls', 'coc-tsserver', 'coc-pyright',
--         \ 'coc-json', 'coc-html', 'coc-css', 'coc-sql', 'coc-highlight', 'coc-snippets']
--         if index(installed,ext) == -1
--             execute 'CocInstall '.ext
--         endif
--     endfor
-- endfunction
-- 
-- Miscellaneous settings   {{{1
-- opt.path+=**
opt.sidescroll = 1
opt.hidden = true
opt.confirm = true
opt.backspace = 'indent,eol,start'
opt.ttimeoutlen = 10
--opt.diffopt+=iwhite
g.mapleader = ' '
-- 
-- Markdown settings
-- let g:markdown_folding = 1
-- let g:markdown_fenced_languages = ['vim','sql','cs','ps1']
-- 
-- Searching settings (See plugin/better_search.vim for new * mapping)   {{{2
opt.ignorecase = true
opt.smartcase = true
-- 
-- Command line options   {{{1
opt.history = 1000
opt.wildignorecase = true
-- set wildignore+=*.a,*.o,*.beam
-- set wildignore+=*.bmp,*.gif,*.jpg,*.ico,*.png
-- set wildignore+=.DS_Store,.git,.ht,.svn
-- set wildignore+=*~,*.swp,*.tmp
-- 
-- Tab settings and behavior   {{{1
opt.smartindent = true
opt.softtabstop = 4
opt.tabstop = 4 
opt.shiftwidth = 4
opt.expandtab = true
-- 
-- Which things are displayed on screen?   {{{1
opt.showmode = false
opt.showmatch = true
opt.number = true
opt.fillchars = 'stl: ,stlnc: ,vert: ,eob: ,fold:‧'
opt.list = true
opt.listchars = 'tab:●·,extends:→,precedes:←,trail:■'
opt.laststatus = 2
-- 
-- Undo/Backup/Swap file settings   {{{1
-- execute 'set   undodir='.fnamemodify($MYVIMRC,':p:h').'/cache/undo//      undofile undolevels=500'
-- execute 'set backupdir='.fnamemodify($MYVIMRC,':p:h').'/cache/backups//   nobackup'
-- execute 'set directory='.fnamemodify($MYVIMRC,':p:h').'/cache/swapfiles//'
-- if !isdirectory(&undodir)   | call mkdir(&undodir, 'p') | endif
-- if !isdirectory(&backupdir) | call mkdir(&backupdir, 'p') | endif
-- if !isdirectory(&directory) | call mkdir(&directory, 'p') | endif
-- 
-- Window behavior and commands   {{{1
opt.splitbelow = true
opt.splitright = true
opt.winminheight = 0
opt.winminwidth = 0

-- Shortcut to <C-W> because of the MacBook's stupid Ctrl key placement
local opts = {noremap=true, silent=true}
map('n', '<leader>w', '<C-W>', opts)

-- Resize windows
map('n', '<Up>', '5<C-W>+', opts)
map('n', '<Down>', '5<C-W>-', opts)
map('n', '<Right>', '10<C-W>>', opts)
map('n', '<Left>', '10<C-W><', opts)
map('n', '<S-Up>', '<C-W>+', opts)
map('n', '<S-Down>', '<C-W>-', opts)
map('n', '<S-Right>', '<C-W>>', opts)
map('n', '<S-Left>', '<C-W><', opts)
map('n', '<leader>x', '<C-W>_<C-W>|', opts)
--
-- Switch Between Windows and Tabs
-- function! WinTabSwitch(direction)
--     let info = getwininfo(win_getid())[0]
--     let wincol = win_screenpos(winnr())[1]
--     if a:direction == 'h' && wincol <= 1
--         execute 'tabprev|99wincmd l'
--     elseif a:direction == 'l' && wincol + info.width >= &columns
--         execute 'tabnext|99wincmd h'
--     else
--         execute 'wincmd '.a:direction
--     endif
-- endfunction
-- 
map('n', '<C-h>', '<Cmd>call WinTabSwitch("h")<CR>', opts)
map('n', '<C-j>', '<Cmd>call WinTabSwitch("j")<CR>', opts)
map('n', '<C-k>', '<Cmd>call WinTabSwitch("k")<CR>', opts)
map('n', '<C-l>', '<Cmd>call WinTabSwitch("l")<CR>', opts)
map('t', '<C-h>', '<C-\\><C-n><Cmd>call WinTabSwitch("h")<CR>', opts)
map('t', '<C-j>', '<C-\\><C-n><Cmd>call WinTabSwitch("j")<CR>', opts)
map('t', '<C-k>', '<C-\\><C-n><Cmd>call WinTabSwitch("k")<CR>', opts)
map('t', '<C-l>', '<C-\\><C-n><Cmd>call WinTabSwitch("l")<CR>', opts)
map('t', '<Esc><Esc>', '<C-\\><C-n>', {noremap = true})
-- 
-- Some helpful remappings {{{1
-- Open a terminal in a split window    {{{2
-- if has("win32") && &shell !~ 'bash'
--     nnoremap <silent> <leader>t <Cmd>split<BAR>terminal pwsh<CR>
--     " Prevent C-Z from freezing the shell
--     noremap <C-Z> nop
-- elseif &shell =~ 'bash'
--     set shell=bash
--     nnoremap <silent> <leader>t <Cmd>split<BAR>terminal<CR>
-- endif
-- 
-- Make # go to the alternate buffer   {{{2
map('n', '#', '<Cmd>buffer #<CR>', opts)

-- Swap j/k with gj/gk {{{2
map('n', 'j', 'gj', opts)
map('n', 'k', 'gk', opts)
map('n', 'gj', 'j', opts)
map('n', 'gk', 'k', opts)

-- Show/hide cursorline and cursorcolumn   {{{2
map('n', '+', '<Cmd>set cursorline! cursorcolumn!<CR>', opts)
map('n', '-', '<Cmd>set cursorline!<CR>', opts)
map('n', '|', '<Cmd>set cursorcolumn!<CR>', opts)

-- Change cwd to current buffer's directory   {{{2
map('n', '<leader>cd', '<Cmd>cd %:p:h<Bar>pwd<CR>', opts)

-- Fold-related mappings {{{2
-- Don't allow o to work on a fold.
-- nnoremap <expr> o foldclosed('.')==-1 ? "o" : ""
-- Focus on the current fold, opening it and closing all others.
map('n', '<leader>z', 'zMzvzz', opts)

-- Insert current date and/or time in insert mode {{{2
map('i', 'Dt', '=strftime("%m/%d/%y %H:%M:%S")<CR><Space>', opts)
map('i', 'Dd', '=strftime("%m/%d/%y")<CR><Space>', opts)
map('i', 'Tt', '=strftime("%H:%M:%S")<CR><Space>', opts)
map('i', 'Dj', '* **=strftime("%d")<CR>**:<Space>', opts)

-- Fix the closest prior misspelling {{{2
map('n', '<F2>', '★<Esc>[s1z=/★<CR>s', opts)
map('n', '<F2>', 'i★<Esc>[s1z=/★<CR>x', opts)
-- 
-- Make an easier redo mapping. Who uses U anyway?   {{{2
map('n', 'U', '<C-R>', opts)
-- 
-- Auto-command Definitions   {{{1
-- augroup mySetup
--     autocmd!
-- 
--     " Remove, display/hide trailing whitespace   {{{2
--     autocmd BufWrite * %s/\s\+$//ce
--     autocmd InsertEnter * :set listchars-=trail:■
--     autocmd InsertLeave * :set listchars+=trail:■
-- 
--     " Turn off line numbers in Terminal windows.   {{{2
--     autocmd TermOpen * setlocal nonumber | startinsert
-- 
--     " Keep cursor in original position when switching buffers   {{{2
--     if !&diff
--         autocmd BufLeave * let b:winview = winsaveview()
--         autocmd BufEnter * if exists('b:winview') | call winrestview(b:winview) | endif
--     endif
-- 
--     " Make 'autoread' work more responsively   {{{2
--     autocmd BufEnter    * silent! checktime
--     autocmd CursorHold  * silent! checktime
--     autocmd CursorMoved * silent! checktime
-- 
--     " Restart with cursor in the location from last session.   {{{2
--     autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
-- augroup END
-- 
-- Settings for 3rd-party plugins {{{1
-- MatchUp   {{{2
g.matchup_matchparen_offscreen = {method='popup'}

-- Crease   {{{2
g.crease_foldtext = {default='%{repeat(">",v:foldlevel)}%{repeat(" ",v:foldlevel)}%t %{gitgutter#fold#is_changed()?"⭐":""} %=[%l lines]'}

-- CSV   {{{2
g.no_csv_maps = 1

-- COC   {{{2
--     set shortmess+=c
--     set signcolumn=yes
-- 
--     " Use tab for trigger completion with characters ahead and navigate.
--     " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
--     " other plugin before putting this into your config.
--     inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
--     inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
-- 
--     " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
--     " position. Coc only does snippet and additional edit on confirm.
--     " <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
--     if exists('*complete_info')
--         inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>\<CR>" : "\<C-g>u\<CR>"
--     else
--         inoremap <expr> <cr> pumvisible() ? "\<C-y>\<CR>" : "\<C-g>u\<CR>"
--     endif
-- 
--     " Use `[g` and `]g` to navigate diagnostics
--     " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
--     nmap <silent> [g <Plug>(coc-diagnostic-prev)
--     nmap <silent> ]g <Plug>(coc-diagnostic-next)
-- 
--     " GoTo code navigation.
--     nmap <silent> gd <Plug>(coc-definition)
--     nmap <silent> gy <Plug>(coc-type-definition)
--     nmap <silent> gi <Plug>(coc-implementation)
--     nmap <silent> gr <Plug>(coc-references)
-- 
--     " Use K to show documentation in preview window.
--     nnoremap <silent> K <Cmd>call <SID>show_documentation()<CR>
-- 
--     function! s:show_documentation()
--         if (index(['vim','help'], &filetype) >= 0)
--             execute 'h '.expand('<cword>')
--         else
--             call CocAction('doHover')
--         endif
--     endfunction
-- 
--     " Highlight the symbol and its references when holding the cursor.
--     autocmd CursorHold * silent call CocActionAsync('highlight')
-- 
--     inoremap <nowait><expr> <PageDown> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : ""
--     inoremap <nowait><expr> <PageUp>   coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : ""
--     inoremap <nowait><expr> <Down> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1,1)\<cr>" : ""
--     inoremap <nowait><expr> <Up>   coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0,1)\<cr>" : ""
-- 
-- MinTree
g.MinTreeExpanded='▼'
g.MinTreeCollapsed='▶'
g.MinTreeOpen='l'
g.MinTreeCloseParent='h'
g.MinTreeOpenTab='T'
g.MinTreeTagAFile='t'
map('n', '<leader>o', '<Cmd>MinTree<CR>', opts)
map('n', '<leader>f', '<Cmd>MinTreeFind<CR>', opts)

-- BufSelect   {{{2
g.BufSelectKeyDeleteBuffer='w'
g.BufSelectKeyOpen='l'
map('n', '<leader>b', '<Cmd>ShowBufferList<CR>', opts)

-- Presenting   {{{2
g.presenting_quit = '<Esc>'
g.presenting_next = '<Right>'
g.presenting_prev = '<Left>'

-- Fugitive   {{{2
map('n', '<F3>', '"zyiw/<C-R>z<CR>:Ggrep -i -e \'<C-R>z\'<CR><CR>:copen<CR>:redraw!<CR>', opts)
map('v', '<F3>', '"zy/<C-R>z<CR>:Ggrep -i -e \'<C-R>z\'<CR><CR>:copen<CR>:redraw!<CR>', opts)
map('n', '<leader>G', '<Cmd>Git<CR>', opts)

-- REST Console   {{{2
g.vrc_show_command = 1
g.vrc_trigger = '<leader>r'

-- Undotree   {{{2
map('n', '<leader>u', '<Cmd>UndotreeToggle<CR>', opts)
g.undotree_WindowLayout = 2
g.undotree_HelpLine = 0
g.undotree_ShortIndicators = 1

-- EasyAlign   {{{2
map('v', '<Enter>', '<Plug>(LiveEasyAlign)', {})

-- vim-sessions   {{{2
--     set sessionoptions-=help
--     set sessionoptions-=blank

-- unicode   {{{2
map('n', 'ga', '<Cmd>UnicodeName<CR>', opts)
map('n', '<leader>k', ':UnicodeSearch!<space>', opts)

-- Color, Tabline, and Statusline Settings   {{{1
-- augroup mySetup
--     autocmd TermOpen,WinEnter * execute 'setlocal winhighlight='.(&buftype=='terminal'?'StatusLine:StatusLineTerm':'')
--     autocmd ColorScheme * call <SID>TweakColors()
--     autocmd InsertEnter,InsertChange,TextChangedI * call <SID>StatuslineColor(1)
--     autocmd VimEnter,InsertLeave,TextChanged,BufWritePost,BufEnter * call <SID>StatuslineColor(0)
-- augroup END
-- 
-- function! s:TweakColors()
--     highlight! link VertSplit StatusLineNC
--     " Status Line - custom colors for status line items and background.
--     highlight StatusLineTerm gui=none guifg=#000000 guibg=#ffaf00
--     highlight GitBranch      gui=none guifg=#efefe7 guibg=#f54d27
--     highlight Session        gui=none guifg=#000000 guibg=#ffaf00
--     highlight Insert         gui=none guifg=#ffffff guibg=#005fff
--     highlight NormalMod      gui=none guifg=#ffffff guibg=#af0000
--     highlight NormalNoMod    gui=none guifg=#000000 guibg=#00df00
-- endfunction
-- 
-- syntax on " Turn syntax highlighting on.
opt.guifont = 'DroidSansMono NF:h9'
opt.termguicolors = true
opt.background = 'light'
cmd('colorscheme PaperColor')
-- 
-- Dynamic statusline contents and color.   {{{2
-- function! s:StatuslineColor(insertMode)
--     execute 'highlight! link StatusLine ' . (a:insertMode ? 'Insert' : (&modified ? 'NormalMod' : 'NormalNoMod'))
--     redraw!
-- endfunction
-- 
-- set statusline=%3l/%3L\ %3v
-- set statusline+=\ %#GitBranch#%(\ %{fugitive#head(8)}\ %)%*
-- set statusline+=\ %{&ft}
-- set statusline+=\ %{&ff}
-- set statusline+=%(\ %{&readonly?'':''}%{&modified?'':''}%)
-- set statusline+=\ %f
-- set statusline+=%=
-- set statusline+=%#Session#%(\ %{SessionNameStatusLineFlag()}\ %)%*
-- 
-- Custom tabline, showing active window in each tab.   {{{2
-- function! Tabline()
--   let s = ''
--   for i in range(1,tabpagenr('$'))
--     let bufnr = tabpagebuflist(i)[tabpagewinnr(i) - 1]
--     let bufname = bufname(bufnr)
--     let s .= '%'.i.'T' . (i == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
--     let s .= ' ' . (bufname!='' ? fnamemodify(bufname,':t') : '?')
--     let s .= (getbufvar(bufnr,'&modified') ? '  ' : ' ')
--   endfor
--   return s . '%#TabLineFill#'
-- endfunction
-- 
-- set tabline=%!Tabline()
