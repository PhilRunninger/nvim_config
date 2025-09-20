for k,v in pairs(
    {
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
        fillchars = {stl=' ', stlnc=' ', eob=' ', fold='⋯'},
        foldtext = [[printf('%-.*s   %s%d ', winwidth(0)/2, trim(substitute(getline(v:foldstart),'\s*{{{\d\+','',''),'',2), strcharpart('▏▎▍▌▋▊▉█',min([v:foldlevel-1,7]),1), v:foldend-v:foldstart+1)]],
        list = true,
        listchars = {tab='●·', extends='→', precedes='←', trail='■'},
        undofile = true,
        splitbelow = true,
        splitright = true,
        winminheight = 0,
        winminwidth = 0,
        shell =        string.find(vim.o.shell,'bash') and 'bash' or 'pwsh',
        shellcmdflag = string.find(vim.o.shell,'bash') and '-c'   or '-NoLogo -NonInteractive -ExecutionPolicy RemoteSigned -Command',
        shellquote = '"',
        shellxquote = '',
        termguicolors = true,
        completeopt = {'menuone', 'noselect', 'fuzzy', 'popup'}
    }) do
    vim.opt[k] = v
end

vim.opt.path:append('**')
vim.opt.diffopt:append('iwhite')
vim.opt.sessionoptions:remove('help')
vim.opt.sessionoptions:remove('blank')
