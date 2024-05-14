vim.opt.tabline = "%!luaeval('SetTabLine()')"

function SetTabLine()
    local tabline = '%#Tabline#'
    local isSelected = false
    local prevIsSelected = false

    for tab = 1,vim.fn.tabpagenr('$'),1 do
        isSelected = tab == vim.fn.tabpagenr()

        local window = vim.fn.tabpagewinnr(tab)
        local buftype = vim.fn.gettabwinvar(tab, window, '&buftype')
        local bufnr = vim.fn.tabpagebuflist(tab)[window]
        local bufname = vim.fn.fnamemodify(vim.fn.bufname(bufnr),':t')

        bufname = buftype == '' and (bufname == '' and 'New…' or bufname) or buftype
        bufname = (vim.bo[bufnr].modified and '  ' or ' ') .. bufname .. ' '

        tabline = tabline .. '%' .. tab .. 'T'
        if tab > 1 and not prevIsSelected and not isSelected then tabline = tabline .. '|' end
        if isSelected then bufname = '%#TabLineSel#' .. bufname .. '%#TabLine#' end
        tabline = tabline .. bufname

        prevIsSelected = isSelected
    end
    return tabline .. '%#TabLineFill#'
end
