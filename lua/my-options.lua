local opt = vim.opt
local cmd = vim.cmd

local options = {
    sidescroll = 1,
    hidden = true,
    confirm = true,
    backspace = {'indent', 'eol', 'start'},
    ttimeoutlen = 10,
    ignorecase = true,
    smartcase = true,
    history = 1000,
    wildignorecase = true,
    wildignore = {'*.a', '*.o', '*.beam', '*.bmp', '*.gif', '*.jpg', '*.ico', '*.png', '.DS_Store', '.git'},
    smartindent = true,
    softtabstop = 4,
    tabstop = 4,
    shiftwidth = 4,
    expandtab = true,
    showmode = false,
    showmatch = true,
    number = true,
    fillchars = {stl=' ', stlnc=' ', eob=' ', fold='‧'},
    list = true,
    listchars = {tab='●·', extends='→', precedes='←', trail='■'},
    laststatus = 3,
    undofile = true,
    splitbelow = true,
    splitright = true,
    winminheight = 0,
    winminwidth = 0,
    shell = string.find(vim.o.shell,'bash') and 'bash' or vim.o.shell,
    termguicolors = true,
    statusline = '%3l/%3L %3v %#GitBranch#%( %{fugitive#head(8)} %)%* %{&ft} %{&ff}%( %{&readonly?\'\':\'\'}%{&modified?\'\':\'\'}%) #%n:%f%=%#Session#%( %{SessionNameStatusLineFlag()} %)%*',
    tabline = '%!Tabline()'
}

opt.path:append('**')
opt.diffopt:append('iwhite')
opt.sessionoptions:remove('help')
opt.sessionoptions:remove('blank')

for k,v in pairs(options) do
    opt[k] = v
end

-- Color, Tabline, and Statusline Settings
cmd([[
    function! s:StatuslineColor(insertMode)
        execute 'highlight! link StatusLine ' . (&buftype=='terminal' ? 'SLTerm' : (a:insertMode ? 'SLInsert' : (&modified ? 'SLNormalMod' : 'SLNormal')))
        redraw!
    endfunction

    augroup auColors
        autocmd!
        autocmd InsertEnter * call <SID>StatuslineColor(1)
        autocmd TermOpen,ColorScheme,InsertLeave,TextChanged,BufWritePost,BufEnter * call <SID>StatuslineColor(0)
        autocmd VimEnter * call timer_start(1, 'DeferredColorSchemeSet')
    augroup END

    function! DeferredColorSchemeSet(timer)
        colorscheme ayu
        syntax on
        call <SID>StatuslineColor(0)
    endfunction

    function! Tabline()
      let s = ''
      for i in range(1,tabpagenr('$'))
        let bufnr = tabpagebuflist(i)[tabpagewinnr(i) - 1]
        let bufname = bufname(bufnr)
        let s .= '%'.i.'T' . (i == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
        let s .= ' ' . (bufname!='' ? fnamemodify(bufname,':t') : '?')
        let s .= (getbufvar(bufnr,'&modified') ? '  ' : ' ')
      endfor
      return s . '%#TabLineFill#'
    endfunction
]])

