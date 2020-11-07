setlocal wrap linebreak nonumber spell

if !executable("grip") || exists('g:started_by_firenvim')
    finish
endif

function! MarkdownStartBrowser(timerID)
    if has("win32")
        call system('start "" http://localhost:'. g:markdownPort)
    elseif has("mac")
        call system('open -g http://localhost:' . g:markdownPort)
    endif
endfunction

function! s:Refresh(buffer)
    if index(g:markdownBuffers, a:buffer) == -1
        call add(g:markdownBuffers, a:buffer)
    endif
    call writefile(getline(1,line('$')), g:markdownTempFile)
endfunction

function! s:CleanUp(buffer)
    call filter(g:markdownBuffers, {_,v -> v != a:buffer})
    if empty(g:markdownBuffers)
        call jobstop(g:markdownJob)
    endif
endfunction

let g:markdownBuffers = get(g:, 'markdownBuffers', [])
let g:markdownPort = get(g:, 'markdownPort', 40500)
let g:markdownTempFile = get(g:, 'markdownTempFile', tempname())
call s:Refresh(string(bufnr('%')))

if !exists("g:markdownJob") || jobwait([g:markdownJob],0)[0] != -1
    let password = exists("$GRIP_TOKEN") ? printf('--pass %s', $GRIP_TOKEN) : ''
    let g:markdownJob = jobstart(printf('grip --title=MarkdownPreview %s %s %d', password, g:markdownTempFile, g:markdownPort))
    call timer_start(5000, 'MarkdownStartBrowser')
endif

autocmd BufEnter,BufWinEnter,CursorHold,CursorHoldI <buffer> call s:Refresh(expand('<abuf>'))
autocmd BufUnload <buffer> call s:CleanUp(expand('<abuf>'))
