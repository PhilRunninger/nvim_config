vim.opt.tabline = "%!luaeval('SetTabLine()')"

function SetTabLine()
    local tabline = '%#TablineFill#'

    for tab = 1,vim.fn.tabpagenr('$'),1 do
        local window = vim.fn.tabpagewinnr(tab)
        local buftype = vim.fn.gettabwinvar(tab, window, '&buftype')
        local bufnr = vim.fn.tabpagebuflist(tab)[window]
        local bufname = vim.fn.fnamemodify(vim.fn.bufname(bufnr),':t')

        bufname = buftype == '' and (bufname == '' and 'New…' or bufname) or buftype
        bufname = bufname .. (vim.bo[bufnr].modified and '🔴' or '')

        tabline = tabline
            .. ' %' .. tab .. 'T'
            .. (tab == vim.fn.tabpagenr() and '%#TabLineSel#' or '%#TabLine#')
            .. ' ' .. bufname .. ' '
            .. '%#TabLineFill#'
    end
    return tabline
end
