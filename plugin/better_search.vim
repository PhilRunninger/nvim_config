let s:words = []

function! s:ToggleWord(word, full)
    let fullWord = '\<'.a:word.'\>'
    let i = index(s:words, a:word)
    let j = index(s:words, fullWord)

    if i >= 0
        call remove(s:words, i)
    elseif j >= 0
        call remove(s:words, j)
    endif

    if (i>=0 && a:full) || (j>=0 && !a:full) || (i<0 && j<0)
        call add(s:words, a:full ? fullWord : a:word)
    endif
    call s:CreateSearchString()
endfunction

function! s:ClearAllWords()
    let s:words = []
    call s:CreateSearchString()
endfunction

function! s:CreateSearchString()
    let @/ = empty(s:words) ? '' : '\(' . join(s:words,'\|') . '\)'
endfunction

nnoremap <silent> *  :call <SID>ToggleWord(expand("<cword>"),1)<CR>
nnoremap <silent> g* :call <SID>ToggleWord(expand("<cword>"),0)<CR>
vnoremap <silent> * "xy:call <SID>ToggleWord(@x,0)<CR>
nnoremap <silent> <leader>* <Cmd>call <SID>ClearAllWords()<CR>

" This function is user2679290's code from https://stackoverflow.com/a/53291200/510067
function! s:Matches(pat)
    let buffer=bufnr("") "current buffer number
    let b:lines=[]
    execute ":%g/".a:pat."/let b:lines+=[{'bufnr':".'buffer'.", 'lnum':"."line('.')".", 'text': escape(getline('.'),'\"')}]"
    call setloclist(0, [], ' ', {'items': b:lines})
    lopen
endfunction

nnoremap <silent> <leader>/ :call <SID>Matches(@/)<CR>
vnoremap <silent> <leader>/ "xy/<C-R>x<CR>:call <SID>Matches(@x)<CR>
