vim.opt.tabline = "%!luaeval('SetTabLine()')"

function SetTabLine()
    local text = vim.fn.tabpagenr() == 1 and '%#TabLineSel#' or '%#TabLine#'                  -- left edge of first tab
    for tab = 1,vim.fn.tabpagenr('$'),1 do
        local bufnr = vim.fn.tabpagebuflist(tab)[vim.fn.tabpagewinnr(tab)]
        local bufname = vim.fn.bufname(bufnr)
        local isSelected = tab == vim.fn.tabpagenr()
        local nextIsSelected = (tab+1) == vim.fn.tabpagenr()
        text = text .. '%' .. tab .. 'T'                                                        -- id for the tab, e.g.:   %1T
                    .. (isSelected and '%#TabLineSel#' or '%#TabLine#') .. ' '                  -- selected tab is accented, others are underlined.
                    .. (vim.api.nvim_buf_get_option(bufnr,'modified') and ' ' or '')           -- "modified" indicator
                    .. (bufname == '' and 'New…' or vim.fn.fnamemodify(bufname,':t')) .. ' '    -- buffer name or 'New…'
                    .. (nextIsSelected and '%#TabLineSel#' or                                  -- left edge of next tab, if selected
                            (isSelected and '%#TabLineSel#' or '%#TabLine#'))                 -- or right edge of current tab
    end
    return text .. '%#TabLineFill#'                                                             -- remainder of tabline
end
