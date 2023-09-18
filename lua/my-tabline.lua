vim.opt.tabline = "%!luaeval('SetTabLine()')"

function SetTabLine()
    local tabline = ''
    local isSelected = false
    local prevIsSelected = false

    for tab = 1,vim.fn.tabpagenr('$'),1 do
        isSelected = tab == vim.fn.tabpagenr()
        local bufnr = vim.fn.tabpagebuflist(tab)[vim.fn.tabpagewinnr(tab)]
        local bufname = vim.fn.fnamemodify(vim.fn.bufname(bufnr),':t')
        tabline = tabline
            .. '%' .. tab .. 'T'
            .. (prevIsSelected and '%#TabLine#' or (isSelected and '%#TabLineSel#' or '%#TabLine#'))
            .. (vim.bo[bufnr].modified and '  ' or ' ')
            .. (bufname == '' and 'New…' or bufname) .. ' '
        prevIsSelected = isSelected
    end
    return tabline .. (prevIsSelected and '' or '') .. '%#TabLineFill#'
end
