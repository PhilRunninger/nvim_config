local opt = vim.opt

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
    tabline = '%!Tabline()'
}

opt.path:append('**')
opt.diffopt:append('iwhite')
opt.sessionoptions:remove('help')
opt.sessionoptions:remove('blank')

for k,v in pairs(options) do
    opt[k] = v
end

vim.cmd([[
    function! Tabline()
      let s = ''
      for i in range(1,tabpagenr('$'))
        let bufnr = tabpagebuflist(i)[tabpagewinnr(i) - 1]
        let bufname = bufname(bufnr)
        let s .= '%'.i.'T' . (i == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
        let s .= ' ' . (bufname!='' ? fnamemodify(bufname,':t') : 'New…')
        let s .= (getbufvar(bufnr,'&modified') ? '  ' : ' ')
      endfor
      return s . '%#TabLineFill#'
    endfunction
]])
