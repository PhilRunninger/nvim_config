vim.opt.tabline = "%!luaeval('SetTabLine()')"
-- vim:foldmethod=marker


function SetTabLine()
    local tabline = '%#TablineFill#'

    for tab = 1,vim.fn.tabpagenr('$'),1 do
        local window = vim.fn.tabpagewinnr(tab)
        local buftype = vim.fn.gettabwinvar(tab, window, '&buftype')
        local bufnr = vim.fn.tabpagebuflist(tab)[window]
        local bufname = vim.fn.fnamemodify(vim.fn.bufname(bufnr),':t')

        tabline = string.format('%s %%%dT%s %s%s %%#TablineFill#',
            tabline,
            tab,
            tab == vim.fn.tabpagenr() and '%#TabLineSel#' or '%#TabLine#',
            buftype == '' and (bufname == '' and 'New…' or bufname) or buftype,
            vim.bo[bufnr].modified and '🔴' or '')
    end
    return tabline
end
