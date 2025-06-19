local group = vim.api.nvim_create_augroup('myAuGroup', {clear = true})

-- Remove, display/hide trailing whitespace
vim.api.nvim_create_autocmd('BufWritePre', {command = 'let [v,c,l]=[winsaveview(),&cuc,&cul]|set cuc cul|keeppatterns %s/\\s\\+$//ce|let [&cuc,&cul]=[c,l]|call winrestview(v)|unlet v l c', group = group})
vim.api.nvim_create_autocmd('InsertEnter', {command = 'set listchars-=trail:■', group = group})
vim.api.nvim_create_autocmd('InsertLeave', {command = 'set listchars+=trail:■', group = group})

-- Turn off line numbers in Terminal windows.
vim.api.nvim_create_autocmd('TermOpen', {command = 'setlocal nonumber norelativenumber | startinsert', group = group})
vim.api.nvim_create_autocmd('BufEnter', {command = 'if &buftype=="terminal"|startinsert|endif', group = group})

-- Close Terminal window automatically if it didn't throw an error.
vim.api.nvim_create_autocmd('TermClose', {command = 'if !v:event.status && expand("<afile>") !~# "vifm: " | execute "bdelete! ".expand("<abuf>") | endif', group = group})

-- Make 'autoread' work more responsively
vim.api.nvim_create_autocmd({'BufEnter','CursorHold','CursorMoved'}, {command = 'silent! checktime', group = group})

-- Restart with cursor in the location from last session.
vim.api.nvim_create_autocmd('BufReadPost', {command = 'if &filetype != "gitcommit" && line("\'\\\"") > 1 && line("\'\\\"") <= line("$") | execute "normal! g`\\\"" | endif', group = group})

-- Turn off formatoptions=o for every file. Must be here, after ftplugin/*.vim runs.
vim.api.nvim_create_autocmd('BufWinEnter', {callback = function() vim.opt.formatoptions:remove('o') end, group = group})
