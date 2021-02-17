" vim: foldmethod=marker

" Plugin Management (Comment a line to temporarily disable a plugin.)  {{{1
" Coding / Development
packadd! coc.nvim              " git@github.com:neoclide/coc.nvim.git
packadd! mintree               " git@github.com:PhilRunninger/mintree.git
packadd! bufselect.vim         " git@github.com:PhilRunninger/bufselect.vim.git
packadd! vim-fugitive          " git@github.com:tpope/vim-fugitive
packadd! vim-gitgutter         " git@github.com:airblade/vim-gitgutter
packadd! vim-commentary        " git@github.com:tpope/vim-commentary.git
packadd! vim-rest-console      " git@github.com:diepm/vim-rest-console.git
packadd! Windows-PowerShell-Syntax-Plugin  " git@github.com:vim-scripts/Windows-PowerShell-Syntax-Plugin.git
" Colorschemes
packadd! gruvbox               " git@github.com:morhetz/gruvbox.git
packadd! xterm-color-table.vim " git@github.com:guns/xterm-color-table.vim
" Filetype-specific
packadd! ldraw.vim             " git@github.com:vim-scripts/ldraw.vim.git
packadd! csv.vim               " git@github.com:chrisbra/csv.vim
" Miscellaneous Utilities
packadd! vim-cool              " git@github.com:romainl/vim-cool.git
packadd! undotree              " git@github.com:mbbill/undotree
packadd! vim-easy-align        " git@github.com:junegunn/vim-easy-align
packadd! vim-sessions          " git@github.com:PhilRunninger/vim-sessions.git
packadd! vim-signature         " git@github.com:kshenoy/vim-signature
packadd! vim-repeat            " git@github.com:tpope/vim-repeat
packadd! vim-surround          " git@github.com:tpope/vim-surround
packadd! vim-unimpaired        " git@github.com:tpope/vim-unimpaired
packadd! vim-exchange          " git@github.com:tommcdo/vim-exchange.git
packadd! vim-fuzzysearch       " git@github.com:ggVGc/vim-fuzzysearch.git
packadd! unicode.vim           " git@github.com:chrisbra/unicode.vim.git
packadd! scratch.vim           " git@github.com:mtth/scratch.vim
packadd! tabline.vim           " git@github.com:mkitt/tabline.vim.git
packadd! presenting.vim        " git@github.com:sotte/presenting.vim.git
" Firefox extension to embed Neovim.
packadd! firenvim              " git@github.com:glacambre/firenvim.git

" Must come AFTER the :packadd! calls above; otherwise, the contents of package 'ftdetect'
" directories won't be evaluated.
filetype indent plugin on

" Function to ensure all my CoC extension are installed.
function InstallCocExtensions()
    let installed = map(CocAction('extensionStats'), {_,v -> v.id})
    for ext in ['coc-vimlsp', 'coc-omnisharp', 'coc-angular', 'coc-erlang_ls', 'coc-tsserver',
        \ 'coc-json', 'coc-html', 'coc-css',
        \ 'coc-snippets']
        if index(installed,ext) == -1
            execute 'CocInstall '.ext
        endif
    endfor
endfunction

" Miscellaneous settings   {{{1
set path+=**                        " search recursively for files with :find
set autoread                        " automatically read file when changed outside of vim
set scrolloff=3 sidescrolloff=3     " minimum # of rows/columns from cursor to edge of window
set sidescroll=1                    " Minimum number of columns to scroll horizontal
set nostartofline                   " [do not] move cursor to first non-blank column when paging
set hidden                          " don't unload buffer when it is abandoned
set confirm                         " Ask what to do with unsave/read-only files
set backspace=indent,eol,start      " How backspace works at start of line
set ttimeoutlen=10                  " Time out time for key codes in milliseconds (Removes delay after <Esc> in Command mode.)
set diffopt+=iwhite
let mapleader=' '                   " Character to use for <leader> mappings

" Disable netrw
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

" Markdown settings
let g:markdown_folding = 1
let g:markdown_fenced_languages = ['vim']

" Searching settings (See plugin/better_search.vim for new * mapping)   {{{2
set hlsearch incsearch
set ignorecase smartcase
runtime macros/matchit.vim

" Command line options   {{{1
set history=1000
set wildmenu wildignorecase
set wildignore+=*.a,*.o,*.beam
set wildignore+=*.bmp,*.gif,*.jpg,*.ico,*.png
set wildignore+=.DS_Store,.git,.ht,.svn
set wildignore+=*~,*.swp,*.tmp

" Tab settings and behavior   {{{1
set autoindent smartindent
set softtabstop=4 tabstop=4 shiftwidth=4 expandtab

" Which things are displayed on screen?   {{{1
set showcmd         " show (partial) command in last line of screen
set noshowmode      " [no] message on status line show current mode
set showmatch       " briefly jump to matching bracket if inserting one
set number          " print the line number in front of each line
set fillchars=stl:\ ,stlnc:\ ,vert:\  " characters to use for displaying special items
set laststatus=2                      " tells when last window has status line

" Undo/Backup/Swap file settings   {{{1
execute 'set   undodir='.fnamemodify($MYVIMRC,':p:h').'/cache/undo//      undofile undolevels=500'
execute 'set backupdir='.fnamemodify($MYVIMRC,':p:h').'/cache/backups//   nobackup'
execute 'set directory='.fnamemodify($MYVIMRC,':p:h').'/cache/swapfiles//'
if !isdirectory(&undodir)   | call mkdir(&undodir, 'p') | endif
if !isdirectory(&backupdir) | call mkdir(&backupdir, 'p') | endif
if !isdirectory(&directory) | call mkdir(&directory, 'p') | endif

" Disable the bells (audible and visual).   {{{1
set noerrorbells visualbell

" Window behavior and commands   {{{1
set splitbelow splitright          " new window is put below or right of the current one
set winminheight=0 winminwidth=0   " minimum number of rows or columns for any window

" Shortcut to <C-W> because of the MacBook's stupid Ctrl key placement
nnoremap <silent> <leader>w <C-W>

" Resize windows
nnoremap <silent> <Up> 5<C-W>+
nnoremap <silent> <Down> 5<C-W>-
nnoremap <silent> <Right> 10<C-W>>
nnoremap <silent> <Left> 10<C-W><
nnoremap <silent> <S-Up> <C-W>+
nnoremap <silent> <S-Down> <C-W>-
nnoremap <silent> <S-Right> <C-W>>
nnoremap <silent> <S-Left> <C-W><
nnoremap <silent> <leader>x <C-W>_<C-W>\|

" Switch Between Windows and Tabs
function! WinTabSwitch(direction)
    let info = getwininfo(win_getid())[0]
    let wincol = win_screenpos(winnr())[1]
    if a:direction == 'h' && wincol <= 1
        execute 'tabprev|99wincmd l'
    elseif a:direction == 'l' && wincol + info.width >= &columns
        execute 'tabnext|99wincmd h'
    else
        execute 'wincmd '.a:direction
    endif
endfunction

nnoremap <silent> <C-h> <Cmd>call WinTabSwitch('h')<CR>
nnoremap <silent> <C-j> <Cmd>call WinTabSwitch('j')<CR>
nnoremap <silent> <C-k> <Cmd>call WinTabSwitch('k')<CR>
nnoremap <silent> <C-l> <Cmd>call WinTabSwitch('l')<CR>
tnoremap <silent> <C-h> <C-\><C-n><Cmd>call WinTabSwitch('h')<CR>
tnoremap <silent> <C-j> <C-\><C-n><Cmd>call WinTabSwitch('j')<CR>
tnoremap <silent> <C-k> <C-\><C-n><Cmd>call WinTabSwitch('k')<CR>
tnoremap <silent> <C-l> <C-\><C-n><Cmd>call WinTabSwitch('l')<CR>
tnoremap <Esc><Esc> <C-\><C-n>

" Some helpful remappings {{{1
" Open a terminal in a split window    {{{2
if has("win32") && &shell !~ 'bash'
    nnoremap <silent> <leader>t <Cmd>split<BAR>terminal pwsh<CR>
    " Prevent C-Z from freezing the shell
    noremap <C-Z> nop
elseif &shell =~ 'bash'
    set shell=bash
    nnoremap <silent> <leader>t <Cmd>split<BAR>terminal<CR>
endif

" Make # go to the alternate buffer   {{{2
nnoremap <silent> # <Cmd>buffer #<CR>

" Swap j/k with gj/gk {{{2
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

" Show/hide cursorline and cursorcolumn   {{{2
nnoremap <silent> + <Cmd>set cursorline! cursorcolumn!<CR>
nnoremap <silent> - <Cmd>set cursorline!<CR>
nnoremap <silent> \| <Cmd>set cursorcolumn!<CR>

" Change cwd to current buffer's directory   {{{2
nnoremap <leader>cd <Cmd>cd %:p:h<Bar>pwd<CR>

" Fold-related mappings {{{2
" Don't allow o to work on a fold.
nnoremap <expr> o foldclosed('.')==-1 ? "o" : ""
" Focus on the current fold, opening it and closing all others.
nnoremap <leader>z zMzvzz

" Insert current date and/or time in insert mode {{{2
inoremap Dt =strftime("%m/%d/%y %H:%M:%S")<CR><Space>
inoremap Dd =strftime("%m/%d/%y")<CR><Space>
inoremap Tt =strftime("%H:%M:%S")<CR><Space>
inoremap Dj * **=strftime("%d")<CR>**:<Space>

" Fix the closest prior misspelling {{{2
inoremap <F2> ★<Esc>[s1z=/★<CR>s
nnoremap <F2> i★<Esc>[s1z=/★<CR>x

" Make an easier redo mapping. Who uses U anyway?   {{{2
nnoremap U <C-R>

" Auto-command Definitions   {{{1
augroup trailingWhitespace   " Remove, display/hide trailing whitespace   {{{2
    autocmd!
    autocmd BufWrite * %s/\s\+$//ce
    autocmd InsertEnter * :set listchars-=trail:■
    autocmd InsertLeave * :set listchars+=trail:■
augroup END
set list listchars=tab:●·,extends:→,precedes:←,trail:■

augroup terminalSettings     " Turn off line numbers in Terminal windows.   {{{2
    autocmd!
    autocmd TermOpen * setlocal nonumber | startinsert
augroup END

if !&diff                    " Keep cursor in original position when switching buffers   {{{2
    augroup saveAndRestoreView
        autocmd!
        autocmd BufLeave * let b:winview = winsaveview()
        autocmd BufEnter * if exists('b:winview') | call winrestview(b:winview) | endif
    augroup END
endif

if !has('gui_running')       " make autoread work better in the terminal   {{{2
    augroup autoreadHelperForTerminal
        autocmd!
        autocmd BufEnter        * silent! checktime
        autocmd CursorHold      * silent! checktime
        autocmd CursorHoldI     * silent! checktime
        autocmd CursorMoved     * silent! checktime
        autocmd CursorMovedI    * silent! checktime
    augroup END
endif

augroup jumpToLastKnownLocation " Put cursor in the same place you left it.   {{{2
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
augroup END

" Settings for managed plugins {{{1
    " CSV   {{{2
    let g:no_csv_maps = 1

    " COC   {{{2
    set shortmess+=c
    set signcolumn=yes

    " Use tab for trigger completion with characters ahead and navigate.
    " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
    " other plugin before putting this into your config.
    inoremap <silent><expr> <TAB>
                \ pumvisible() ? "\<C-n>" :
                \ <SID>check_back_space() ? "\<TAB>" :
                \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

    function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
    endfunction

    " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
    " position. Coc only does snippet and additional edit on confirm.
    " <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
    if exists('*complete_info')
        inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
    else
        inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
    endif

    " Use `[g` and `]g` to navigate diagnostics
    " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)

    " GoTo code navigation.
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K to show documentation in preview window.
    nnoremap <silent> K <Cmd>call <SID>show_documentation()<CR>

    function! s:show_documentation()
        if (index(['vim','help'], &filetype) >= 0)
            execute 'h '.expand('<cword>')
        else
            call CocAction('doHover')
        endif
    endfunction

    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Firenvim   {{{2
    if exists('g:started_by_firenvim')
        set linebreak nonumber spell signcolumn=no noruler laststatus=0
        set guifont=Cascadia\ Code\ PL:h10
    endif
    let g:firenvim_config = {'globalSettings': {'alt':'all'}, 'localSettings': {}}
    let fc = g:firenvim_config['localSettings']
    let fc['.*'] = {'cmdline':'neovim', 'priority':0, 'selector':'textarea', 'takeover':'never'}
    let fc['https?://github.com'] = {'takeover':'once', 'priority':1}

    " MinTree   {{{2
    let g:MinTreeOpen='l'
    let g:MinTreeCloseParent='h'
    nnoremap <silent> <leader>o <Cmd>MinTree<CR>
    nnoremap <silent> <leader>f <Cmd>MinTreeFind<CR>

    " BufSelect   {{{2
    let g:BufSelectKeyOpen='l'
    nnoremap <silent> <leader>b <Cmd>ShowBufferList<CR>

    " Presenting   {{{2
    let g:presenting_quit = '<Esc>'
    let g:presenting_next = '<Right>'
    let g:presenting_prev = '<Left>'

    " FuzzySearch {{{2
    let g:fuzzysearch_match_spaces = 1
    nnoremap g/ <Cmd>FuzzySearch<CR>

    " Fugitive   {{{2
    nnoremap <silent> <F3> "zyiw/<C-R>z<CR>:Ggrep -e '<C-R>z'<CR><CR>:copen<CR>:redraw!<CR>
    vnoremap <silent> <F3> "zy/<C-R>z<CR>:Ggrep -e '<C-R>z'<CR><CR>:copen<CR>:redraw!<CR>
    nnoremap <leader>G <Cmd>Gstatus<CR>

    " REST Console   {{{2
    let g:vrc_show_command = 1
    let g:vrc_trigger = '<leader>r'

    " Undotree   {{{2
    nnoremap <silent> <leader>u <Cmd>UndotreeShow<CR>
    let g:undotree_SetFocusWhenToggle = 1
    let g:undotree_WindowLayout = 2
    let g:undotree_HelpLine = 0
    let g:undotree_ShortIndicators = 1

    " EasyAlign   {{{2
    vmap <Enter> <Plug>(LiveEasyAlign)

    " Scratch   {{{2
    let g:scratch_insert_autohide = 0
    let g:scratch_no_mappings = 1
    let g:scratch_persistence_file = fnamemodify($MYVIMRC,':p:h').'/cache/scratch.txt'
    nnoremap gs <Cmd>Scratch<CR>
    nnoremap gS <Cmd>Scratch!<CR>
    xnoremap gs <Cmd>ScratchSelection<CR>
    xnoremap gS <Cmd>ScratchSelection!<CR>

    " vim-sessions   {{{2
    set sessionoptions-=help
    set sessionoptions-=blank

    " unicode   {{{2
    nnoremap ga <Cmd>UnicodeName<CR>
    inoremap <C-K> <Esc>:UnicodeSearch!<space>

" Color Settings   {{{1
syntax on                           " Turn syntax highlighting on.

augroup setStatuslineColor    " Change statusline color, depending on mode.
    autocmd!
    autocmd InsertEnter,InsertChange,TextChangedI * call <SID>StatuslineColor(1)
    autocmd VimEnter,InsertLeave,TextChanged,BufWritePost,BufEnter * call <SID>StatuslineColor(0)
augroup END

augroup tweakColorScheme
    autocmd!
    autocmd ColorScheme * highlight Normal                               ctermbg=none " Use terminal's Background color setting
    autocmd ColorScheme * highlight Folded         cterm=none ctermfg=8  ctermbg=234  " Gray on Almost Black
    autocmd ColorScheme * highlight MatchParen     cterm=bold ctermfg=15 ctermbg=124  " White on Red
    autocmd ColorScheme * highlight WildMenu       cterm=none ctermfg=16 ctermbg=178  " Black on Gold
    autocmd ColorScheme * highlight GitBranch      cterm=none ctermfg=12 ctermbg=17   " Blue on Dark Blue
    autocmd ColorScheme * highlight StatusLine     cterm=none ctermfg=16 ctermbg=40   " Black on Green
    autocmd ColorScheme * highlight StatusLineTerm cterm=none ctermfg=16 ctermbg=208  " Black on Gold
    autocmd ColorScheme * highlight! link Session WildMenu
    autocmd ColorScheme * highlight! link VertSplit StatusLineNC
    autocmd TermOpen,WinEnter *
           \ if &buftype=='terminal' |
           \     setlocal winhighlight=StatusLine:StatusLineTerm|
           \ else |
           \     setlocal winhighlight= |
           \ endif
    autocmd ColorScheme * highlight Insert         cterm=none ctermfg=15 ctermbg=27   " White on Blue
    autocmd ColorScheme * highlight NormalMod      cterm=none ctermfg=15 ctermbg=124  " White on Red
    autocmd ColorScheme * highlight NormalNoMod    cterm=none ctermfg=16 ctermbg=40   " Black on Green
augroup END
colorscheme gruvbox

function! s:StatuslineColor(insertMode)
    execute 'highlight! link StatusLine ' . (a:insertMode ? 'Insert' : (&modified ? 'NormalMod' : 'NormalNoMod'))
    redraw!
endfunction

" Status Line Settings   {{{1
augroup setStatuslineText    " Change statusline text, depending on mode.
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter,BufWritePost * call <SID>StatusLineText()
augroup END

function! Status(winnum)
    let l:statusline=""
    if a:winnum == winnr()
        let l:statusline.="%3v"
        let l:statusline.="\ %#GitBranch#%(\ %{fugitive#head(8)}\ %)%*"
        let l:statusline.="\ %{&ft}"
        let l:statusline.="\ %{&ff}"
        let l:statusline.="%(\ %R%m%)"
        let l:statusline.="\ %f"
        let l:statusline.="%="
        let l:statusline.="%#Session#%(\ %{SessionNameStatusLineFlag()}\ %)%*"
    else
        let l:statusline.="%(\ %R%m%)"
        let l:statusline.="\ %F"
    endif
    return l:statusline
endfunction

function! s:StatusLineText()
    let l:exempt  = ['']                        " No name (Quickfix/Location list, new file, etc.)
    let l:exempt += ['.*[/\\]doc[/\\]\w*\.txt'] " Help files
    let l:exempt += ['=MinTree=']               " MinTree
    let l:exempt += ['NERD_tree_\d\+']          " NERDTree
    let l:exempt += ['=Buffers=']               " BufSelect list
    for nr in range(1, winnr('$'))
        if bufname(winbufnr(nr)) !~# '^\(' . join(l:exempt,'\|') . '\)$'
            call setwinvar(nr, '&statusline', '%!Status('.nr.')')
        endif
    endfor
endfunction
