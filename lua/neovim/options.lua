-- vim:foldmethod=marker

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
        relativenumber = true,
        fillchars = {stl=' ', stlnc=' ', eob=' ', fold='⋯'},
        foldtext = 'v:lua.MyFoldText()',
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

function MyFoldText()
    local line = vim.fn.getline(vim.v.foldstart)
    local commentString = vim.fn.substitute(vim.bo.commentstring, '\\s*%s\\s*', '', '') -- Remove %s placeholder from &commentstring, e.g. from "-- %s" to "--".
    line = vim.fn.substitute(line, commentString, '', '')                               -- Remove comment markers from the line.
    local foldMarker = vim.fn.substitute(vim.wo.foldmarker, ',', '\\\\|', '')           -- Replace the comma in &foldmarker for use in a pattern.
    line = vim.fn.substitute(line, '\\s*\\('..foldMarker..'\\)\\d*', '', '')            -- Remove fold markers from the line.
    local symbols = {'❶  ','❷  ','❸  ','❹  ','❺  ','❻  ','❼  ','❽  ','❾  ','❾ ⁺'}       -- Symbols to indicate 9+ fold levels
    local nLines = vim.v.foldend - vim.v.foldstart + 1
    return string.format('%s   %s%d', line, symbols[math.min(10, vim.v.foldlevel)], nLines)
end
