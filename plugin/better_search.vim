let s:words = []
let s:savedPattern = @/
let s:savedFG = synIDattr(synIDtrans(hlID('Search')), 'fg')
let s:savedBG = synIDattr(synIDtrans(hlID('Search')), 'bg')

function! s:ToggleWord()
    if s:words == []
        let s:savedPattern = @/
    endif

    let l:word = '\<' . expand("<cword>") . '\>'
    let l:i = index(s:words, l:word)
    if l:i >= 0
        call remove(s:words, l:i)
    else
        call add(s:words, l:word)
    endif
    call s:CreateSearchString()
endfunction

function! s:CreateSearchString()
    if empty(s:words)
        let @/ = s:savedPattern
        execute 'highlight Search guifg='. s:savedFG . ' guibg=' . s:savedBG
    else
        let @/ = '\(' . join(s:words,'\|') . '\)'
        highlight Search guifg=#000000 guibg=#afff00
    endif
endfunction

function! s:ClearSearchString()
    let s:words = []
    call s:CreateSearchString()
endfunction

nnoremap <silent> * <Cmd>call <SID>ToggleWord()<CR>n
nnoremap <silent> <leader>* <Cmd>call <SID>ClearSearchString()<CR>
nnoremap <silent> <leader><leader>* <Cmd>nohlsearch<CR>

vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
nnoremap <silent> <leader>/ :vimgrep "<C-R>/" %<CR>n:copen<CR>
vnoremap <silent> <leader>/ y:vimgrep "<C-R>0" %<CR>/<C-R>0<CR>:copen<CR>
