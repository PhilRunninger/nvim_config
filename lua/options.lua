-- vim:foldmethod=marker

-- Fixed-value settings {{{1
for k,v in pairs({
        clipboard = 'unnamed',
        completeopt = {'menuone', 'noselect', 'fuzzy', 'popup'},
        confirm = true,
        expandtab = true,
        fillchars = {stl=' ', stlnc=' ', eob=' ', fold='⠶'},
        foldtext = 'v:lua.MyFoldText()',
        ignorecase = true,
        list = true,
        listchars = {tab='🢒⸳', extends='→', precedes='←', trail='■', nbsp='□'},
        number = true,
        relativenumber = true,
        shell = string.find(vim.o.shell, 'bash') and 'bash' or vim.o.shell,
        shiftwidth = 4,
        showmatch = true,
        showmode = false,
        smartcase = true,
        smartindent = true,
        softtabstop = 4,
        splitbelow = true,
        splitright = true,
        tabstop = 4,
        termguicolors = true,
        undofile = true,
        wildignore = {'*.a', '*.o', '*.beam', '*.bmp', '*.gif', '*.jpg', '*.ico', '*.png', '.DS_Store', '.git'},
        wildignorecase = true,
        winborder = 'bold',
        winminheight = 0,
        winminwidth = 0,
    }) do
    vim.opt[k] = v
end

-- Modifications of existing options {{{1
vim.opt.path:append('**')
vim.opt.diffopt:append('iwhite')
vim.opt.sessionoptions:remove('help')
vim.opt.sessionoptions:remove('blank')

-- Markdown settings. I put it here because it's a built-in plugin. {{{1
vim.g.markdown_folding = 1
vim.g.markdown_fenced_languages = { 'vim', 'sql', 'cs', 'ps1', 'lua', 'json', 'mermaid' }

-- Disable built-in stuff I don't use.  {{{1
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0

vim.g.loaded = 1
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1

-- My custom foldtext function {{{1
function MyFoldText()
    local line = vim.fn.getline(vim.v.foldstart)
    local commentString = vim.fn.substitute(vim.bo.commentstring, '\\s*%s\\s*', '', '') -- Remove %s placeholder from &commentstring, e.g. from "-- %s" to "--".
    line = vim.fn.substitute(line, commentString, '', '')                               -- Remove comment markers from the line.
    local foldMarker = vim.fn.substitute(vim.wo.foldmarker, ',', '\\\\|', '')           -- Replace the comma in &foldmarker for use in a pattern.
    line = vim.fn.substitute(line, '\\s*\\('..foldMarker..'\\)\\d*', '', '')            -- Remove fold markers from the line.
    local symbols = {'❶ ','❷ ','❸ ','❹ ','❺ ','❻ ','❼ ','❽ ','❾ ','❿ +'}                -- Symbols to indicate 9 or more fold levels
    local nLines = vim.v.foldend - vim.v.foldstart + 1
    return string.format('%s        %s·%d ', line, symbols[math.min(10, vim.v.foldlevel)], nLines)
end
