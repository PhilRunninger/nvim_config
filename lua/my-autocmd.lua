local group = vim.api.nvim_create_augroup('myAuGroup', {clear = true})

-- Remove, display/hide trailing whitespace
vim.api.nvim_create_autocmd('BufWritePre', {command = 'let [v,c,l]=[winsaveview(),&cuc,&cul]|set cuc cul|keeppatterns %s/\\s\\+$//ce|let [&cuc,&cul]=[c,l]|call winrestview(v)|unlet v l c', group = group})
vim.api.nvim_create_autocmd('InsertEnter', {command = 'set listchars-=trail:■', group = group})
vim.api.nvim_create_autocmd('InsertLeave', {command = 'set listchars+=trail:■', group = group})

-- Turn off line numbers in Terminal windows.
vim.api.nvim_create_autocmd('TermOpen', {command = 'setlocal nonumber | startinsert', group = group})

-- Keep cursor in original position when switching buffers
if not vim.o.diff then
    vim.api.nvim_create_autocmd('BufLeave', {command = 'let b:winview = winsaveview()', group = group})
    vim.api.nvim_create_autocmd('BufEnter', {command = 'if exists("b:winview") | call winrestview(b:winview) | endif', group = group})
end

-- Make 'autoread' work more responsively
vim.api.nvim_create_autocmd('BufEnter',    {command = 'silent! checktime', group = group})
vim.api.nvim_create_autocmd('CursorHold',  {command = 'silent! checktime', group = group})
vim.api.nvim_create_autocmd('CursorMoved', {command = 'silent! checktime', group = group})

-- Restart with cursor in the location from last session.
vim.api.nvim_create_autocmd('BufReadPost', {command = 'if line("\'\\\"") > 1 && line("\'\\\"") <= line("$") | execute "normal! g`\\\"" | endif', group = group})

-- Additional nvim-qt Settings
vim.api.nvim_create_autocmd('UIEnter', {callback = function() require('my-ginit') end, group = group})
