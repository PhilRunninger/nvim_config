" Tab settings
setlocal softtabstop=8   " number of spaces that <tab> uses when editing
setlocal tabstop=8       " number of spaces that <tab> in file uses
setlocal shiftwidth=2    " number of spaces to use for (auto)indent step
setlocal expandtab       " use spaces when <tab> is inserted

" Poor-man's REPL
noremap <buffer> <F5> :write !node<CR>
