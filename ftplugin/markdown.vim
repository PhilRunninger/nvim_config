setlocal wrap linebreak nonumber spell

if !executable("grip") || exists('g:started_by_firenvim')
    finish
endif

augroup markdownPreview
    autocmd!
    autocmd BufWinEnter <buffer> call OpenMarkdownPreview()
    autocmd CursorHold,CursorHoldI <buffer> call s:Refresh()
    autocmd BufUnload <buffer> call s:CleanUp()
augroup END

function! s:CleanUp()
    try
        call jobstop(b:job)
        call delete(b:tempfile)
    catch
    endtry
    autocmd! markdownPreview * <afile>
endfunction

function! s:Refresh()
    call writefile(getline(1,line('$')), b:tempfile)
endfunction

function! OpenMarkdownPreview() abort
    if &ft ==# 'markdown'
        if !exists("b:tempfile")
            let b:tempfile = tempname()
            call s:Refresh()
        endif
        if !exists("b:job") || jobwait([b:job],0)[0] == -1
            let b:port = system("lsof -s tcp:listen -i :40500-40800 | awk -F ' *|:' '{ print $10 }' | sort -n | tail -n1") + 1
            if b:port == 1
                let b:port = 40500
            endif
            if exists("$GRIP_TOKEN")
                let b:job = jobstart('grip --pass ' . $GRIP_TOKEN . ' --title=' . escape(expand('%:t'),' ') . ' ' . b:tempfile . ' ' . b:port)
            else
                let b:job = jobstart('grip --title=' . escape(expand('%:t'),' ') . ' ' . b:tempfile . ' ' . b:port)
            endif

            let l:start = reltime()
            let l:server_up = system('lsof -t -s tcp:listen -i :' . b:port . ' || wc -l') > 0
            while reltimefloat(reltime(l:start)) < 1.0 && l:server_up == 0
                let l:server_up = system('lsof -t -s tcp:listen -i :' . b:port . ' || wc -l') > 0
            endwhile
        endif

        if system('lsof -t -s tcp:established -i :' . b:port . ' || wc -l') == 0
            call system('open -g http://localhost:' . b:port)
        endif
    endif
endfunction
