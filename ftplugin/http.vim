nnoremap <F5> <Plug>RestNvim

nnoremap <buffer><silent> <leader>n :call search('^\(GET\<Bar>POST\<Bar>PUT\<Bar>DELETE\)', 'w')<CR>
nnoremap <buffer><silent> <leader>N :call search('^\(GET\<Bar>POST\<Bar>PUT\<Bar>DELETE\)', 'bw')<CR>
