setlocal errorformat=\ %#%f(%l\\\,%c):\ %m
setlocal makeprg=msbuild\ /nologo\ /v:q\ /property:GenerateFullPaths=true

nnoremap <buffer> <F5> :make run<CR>
nnoremap <buffer> <F6> :make<CR>:copen<CR>
