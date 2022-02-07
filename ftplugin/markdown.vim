setlocal wrap linebreak nonumber spell

if !executable("grip") || exists('g:started_by_firenvim')
    finish
endif

function MarkdownPreview()
  call s:Refresh(string(bufnr('%')))

  if !exists("s:markdownJob") || jobwait([s:markdownJob],0)[0] != -1
    let password = exists("$GRIP_TOKEN") ? printf('--pass %s', $GRIP_TOKEN) : ''
    let s:markdownJob = jobstart(printf('grip -b --title=MarkdownPreview %s %s', password, s:markdownTempFile))
  endif

  augroup _markdownPreviewer
    autocmd!
    autocmd BufEnter,BufWinEnter,CursorHold,CursorHoldI <buffer> call s:Refresh(expand('<abuf>'))
    autocmd BufUnload <buffer> call s:CleanUp(expand('<abuf>'))
  augroup END
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

let s:markdownBuffers = get(s:, 'markdownBuffers', [])
let s:markdownTempFile = get(s:, 'markdownTempFile', tempname())

command! -buffer MarkdownPreview :call MarkdownPreview()
