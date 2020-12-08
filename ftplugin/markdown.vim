setlocal wrap linebreak nonumber spell

if !executable("grip") || exists('g:started_by_firenvim')
    finish
endif

function! MarkdownStartBrowser(timerID)
    if has("win32")
        call system('cmd /c start "" http://localhost:'. g:markdownPort)
    elseif has("mac")
        call system('open -g http://localhost:' . g:markdownPort)
    endif
endfunction

function! s:Refresh(buffer)
    call uniq(sort(add(s:markdownBuffers,a:buffer)))
    call writefile(getline(1,line('$')), s:markdownTempFile)
endfunction

function! s:CleanUp(buffer)
    call filter(s:markdownBuffers, {_,v -> v != a:buffer})
    if empty(s:markdownBuffers)
        call jobstop(s:markdownJob)
    endif
endfunction

let g:markdownPort = get(g:, 'markdownPort', 40500)
let s:markdownBuffers = get(s:, 'markdownBuffers', [])
let s:markdownTempFile = get(s:, 'markdownTempFile', tempname())
call s:Refresh(string(bufnr('%')))

if !exists("s:markdownJob") || jobwait([s:markdownJob],0)[0] != -1
    let password = exists("$GRIP_TOKEN") ? printf('--pass %s', $GRIP_TOKEN) : ''
    let s:markdownJob = jobstart(printf('grip --title=MarkdownPreview %s %s %d', password, s:markdownTempFile, g:markdownPort))
    call timer_start(1000, 'MarkdownStartBrowser')
endif

autocmd BufEnter,BufWinEnter,CursorHold,CursorHoldI <buffer> call s:Refresh(expand('<abuf>'))
autocmd BufUnload <buffer> call s:CleanUp(expand('<abuf>'))
