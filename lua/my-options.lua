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
    tabline = "%!luaeval('SetTabLine()')"
}

opt.path:append('**')
opt.diffopt:append('iwhite')
opt.sessionoptions:remove('help')
opt.sessionoptions:remove('blank')

for k,v in pairs(options) do
    opt[k] = v
end

function SetTabLine()
    local s = {}
    for i = 1,vim.fn.tabpagenr('$'),1 do
        local bufnr = vim.fn.tabpagebuflist(i)[vim.fn.tabpagewinnr(i)]
        local bufname = vim.fn.bufname(bufnr)
        s[i] = string.format('%%%dT%s%s%s', i,
            i == vim.fn.tabpagenr() and '%#TabLineSel#' or '%#TabLine#',
            vim.api.nvim_buf_get_option(bufnr,'modified') and '🔴' or '',
            bufname == '' and 'New…' or vim.fn.fnamemodify(bufname,':t'))
    end
    return table.concat(s, '%#TabLineDivider#┃')
end
