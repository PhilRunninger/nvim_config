local group = vim.api.nvim_create_augroup('myAuGroup', {clear = true})

-- Remove trailing whitespace when saving, if approved.
vim.api.nvim_create_autocmd('BufWritePre', {
    callback = function()
        local view,cuc,cul = vim.fn.winsaveview(), vim.wo.cursorcolumn, vim.wo.cursorline
        vim.wo.cursorcolumn = true
        vim.wo.cursorline = true
        vim.fn.execute([[keeppatterns %s/\s\+$//ce]])
        vim.wo.cursorcolumn = cuc
        vim.wo.cursorline = cul
        vim.fn.winrestview(view)
    end,
    group = group
})

-- Hide trailing whitespace in Insert mode
vim.api.nvim_create_autocmd('InsertEnter', {
    callback = function()
        vim.opt.listchars:remove('trail')
    end,
    group = group
})

-- Display trailing whitespace in Normal mode.
vim.api.nvim_create_autocmd('InsertLeave', {
    callback = function()
        vim.opt.listchars:append( {trail = '■'} )
    end,
    group = group
})

-- Make 'autoread' work more responsively
vim.api.nvim_create_autocmd({'BufEnter','CursorHold','CursorMoved'}, {
    callback = function()
        vim.fn.execute('silent! checktime')
    end,
    group = group
})

-- Restart with cursor in the location from last session.
vim.api.nvim_create_autocmd('BufReadPost', {
    callback = function()
        if vim.bo.filetype ~= 'gitcommit' and vim.fn.line([['"]]) > 1 and vim.fn.line([['"]]) <= vim.fn.line([[$]]) then
            vim.fn.execute([[normal! g`"]])
        end
    end,
    group = group
})
