vim.opt.tabline = "%!luaeval('SetTabLine()')"

function SetTabLine()
    local digits = {'⁰','¹','²','³','⁴','⁵','⁶','⁷','⁸','⁹'}
    local text = '%#TabLineDivider#/'                                                         -- left edge of first tab
    for tab = 1,vim.fn.tabpagenr('$'),1 do
        local displaycount = ''
        local wincount = vim.fn.tabpagewinnr(tab,'$')
        if wincount > 1 then
            while wincount > 0 do
                displaycount = digits[(wincount%10)+1] .. displaycount
                wincount = math.floor(wincount / 10)
            end
        end
        local bufnr = vim.fn.tabpagebuflist(tab)[vim.fn.tabpagewinnr(tab)]
        local bufname = vim.fn.bufname(bufnr)
        text = text .. '%' .. tab .. 'T'                                                      -- id for the tab, e.g.:   %1T
                    .. (tab == vim.fn.tabpagenr() and '%#TabLineSel#' or '%#TabLine#') .. ' ' -- selected tab is accented, others are underlined.
                    .. (vim.api.nvim_buf_get_option(bufnr,'modified') and '🔴' or '')         -- "modified" indicator
                    .. (bufname == '' and 'New…' or vim.fn.fnamemodify(bufname,':t'))         -- buffer name or 'New…'
                    .. displaycount                                                           -- # of windows on tab if it's split
                    .. ' %#TabLineDivider#' .. (tab+1 == vim.fn.tabpagenr() and '/' or '\\')  -- if next tab is selected, left edge else right edge
    end
    return text .. '%#TabLineFill#'                                                           -- top edge of "folders" beyond last tab
end
