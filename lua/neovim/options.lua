for k,v in pairs({
        confirm = true,
        ignorecase = true,
        smartcase = true,
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
        foldtext = [[printf('%s  ▌%d:%d▐', trim(substitute(getline(v:foldstart),'\('.&commentstring->substitute('\s*%s','','').'\)\?\s*{{{\d\+','',''),'',2), v:foldlevel , v:foldend-v:foldstart+1) ]],
        list = true,
        listchars = {tab='🢒⸳', extends='→', precedes='←', trail='■', nbsp='□'},
        undofile = true,
        splitbelow = true,
        splitright = true,
        winminheight = 0,
        winminwidth = 0,
        shell = string.find(vim.o.shell, 'bash') and 'bash' or vim.o.shell,
        termguicolors = true,
        completeopt = {'menuone', 'noselect', 'fuzzy', 'popup'}
    }) do
    vim.opt[k] = v
end

vim.opt.path:append('**')
vim.opt.diffopt:append('iwhite')
vim.opt.sessionoptions:remove('help')
vim.opt.sessionoptions:remove('blank')
