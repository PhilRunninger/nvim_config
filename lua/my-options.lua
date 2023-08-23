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
    local digits = {'⁰','¹','²','³','⁴','⁵','⁶','⁷','⁸','⁹'}
    local s = '%#TabLineDivider#/%#TabLine#'
    for i = 1,vim.fn.tabpagenr('$'),1 do
        local wincount = ''
        local j = #vim.fn.tabpagebuflist(i)
        while j > 0 do
            wincount = digits[(j%10)+1] .. wincount
            j = math.floor(j / 10)
        end
        local bufnr = vim.fn.tabpagebuflist(i)[vim.fn.tabpagewinnr(i)]
        local bufname = vim.fn.bufname(bufnr)
        s = s .. '%' .. i .. 'T'                                                        -- id for the tab, e.g.:   %1T
              .. (i == vim.fn.tabpagenr() and '%#TabLineSel#' or '%#TabLine#') .. ' '   -- selected tab is accented, others are underlined.
              .. (vim.api.nvim_buf_get_option(bufnr,'modified') and '🔴' or '')         -- "modified" indicator
              .. (bufname == '' and 'New…' or vim.fn.fnamemodify(bufname,':t'))         -- buffer name or 'New…'
              .. (wincount == '¹' and '' or wincount)                                   -- # of windows on tab if it's split
              .. ' %#TabLineDivider#' .. (i+1 == vim.fn.tabpagenr() and '/' or '\\')    -- if next tab is selected, left edge else right edge
    end
    return s .. '%#TabLineFill#'
end
