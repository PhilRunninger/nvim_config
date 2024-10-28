let s:words = []

function! s:ToggleWord(fragment, full)
    let countBefore = len(s:words)
    let fullWord = '\<'.a:fragment.'\>'
    let existingFragment = index(s:words, a:fragment)
    let existingWord = index(s:words, fullWord)

    if existingFragment >= 0
        call remove(s:words, existingFragment)
    elseif existingWord >= 0
        call remove(s:words, existingWord)
    endif

    if (existingFragment>=0 && a:full) || (existingWord>=0 && !a:full) || (existingFragment<0 && existingWord<0)
        call add(s:words, a:full ? fullWord : a:fragment)
    endif

    call s:CreateSearchString()

    if len(s:words) > countBefore
        call feedkeys('nN', 'n')
    endif
endfunction

function! s:ClearAllWords()
    let s:words = []
    call s:CreateSearchString()
endfunction

function! s:CreateSearchString()
    echo 'Search ['.len(s:words).' pattern'.(len(s:words)==1?'':'s').']: '. join(s:words, ', ')
    let @/ = empty(s:words) ? '' : '\(' . join(s:words,'\|') . '\)'
endfunction

nnoremap <silent> *  :call <SID>ToggleWord(expand("<cword>"),1)<CR>
nnoremap <silent> g* :call <SID>ToggleWord(expand("<cword>"),0)<CR>
vnoremap <silent> * "xy:call <SID>ToggleWord(@x,0)<CR>
nnoremap <silent> <leader>* :call <SID>ClearAllWords()<CR>
nnoremap <silent> <ESC> :nohlsearch<CR>

" This function is user2679290's code from https://stackoverflow.com/a/53291200/510067
function! s:Matches(pat)
    let buffer=bufnr("") "current buffer number
    let b:lines=[]
    execute ":%g/".a:pat."/let b:lines+=[{'bufnr':".'buffer'.", 'lnum':"."line('.')".", 'text': escape(getline('.'),'\"')}]"
    call setqflist(b:lines)
    call setqflist([], 'a', {'title':a:pat})
    copen
endfunction

nnoremap <silent> <leader>/ :call <SID>Matches(@/)<CR>
vnoremap <silent> <leader>/ "xy/<C-R>x<CR>:call <SID>Matches(@x)<CR>
