vim.opt.tabline = "%!luaeval('SetTabLine()')"

function SetTabLine()
    local tabline = ''
    local isSelected = false
    local prevIsSelected = false

    for tab = 1,vim.fn.tabpagenr('$'),1 do
        isSelected = tab == vim.fn.tabpagenr()
        local bufnr = vim.fn.tabpagebuflist(tab)[vim.fn.tabpagewinnr(tab)]
        local bufname = vim.fn.fnamemodify(vim.fn.bufname(bufnr),':t')
        tabline = tabline .. '%' .. tab .. 'T'
        if prevIsSelected then tabline = tabline .. '%#TabLine#'    -- Selected right edge of previous tab
        elseif isSelected then tabline = tabline .. '%#TabLineSel#' -- Selected left edge of current tab
        elseif tab == 1 then   tabline = tabline .. '%#TabLine#'    -- Unselected left edge of 1st tab
        else                   tabline = tabline .. '%#TabLine#'    -- Unselected right edge of previous tab
        end
        tabline = tabline .. (vim.bo[bufnr].modified and '  ' or ' ')
        tabline = tabline .. (bufname == '' and 'New…' or bufname) .. ' '
        prevIsSelected = isSelected
    end
    return tabline .. (isSelected and '' or '') .. '%#TabLineFill#'
end
