vim.opt.tabline = "%!luaeval('SetTabLine()')"

function SetTabLine()
    local tabline = ''
    local isSelected = false
    local prevIsSelected = false

    for tab = 1,vim.fn.tabpagenr('$'),1 do
        isSelected = tab == vim.fn.tabpagenr()

        local bufnr = vim.fn.tabpagebuflist(tab)[vim.fn.tabpagewinnr(tab)]
        local bufname = vim.fn.fnamemodify(vim.fn.bufname(bufnr),':t')
        bufname = bufname == '' and 'New…' or bufname
        bufname = (vim.bo[bufnr].modified and '  ' or ' ') .. bufname .. ' '

        tabline = tabline .. '%' .. tab .. 'T'
        if tab > 1 and not prevIsSelected and not isSelected then tabline = tabline .. '┃' end
        if isSelected then bufname = '%#TabLineSel#' .. bufname .. '%#TabLine#' end
        tabline = tabline .. bufname
        prevIsSelected = isSelected
    end
    return tabline .. '%#TabLineFill#'
end
