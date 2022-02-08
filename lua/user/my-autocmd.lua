cmd([[
    augroup userAuGeneral
        autocmd!

        " Remove, display/hide trailing whitespace
        autocmd BufWrite * %s/\s\+$//ce
        autocmd InsertEnter * :set listchars-=trail:■
        autocmd InsertLeave * :set listchars+=trail:■

        " Turn off line numbers in Terminal windows.
        autocmd TermOpen * setlocal nonumber | startinsert

        " Keep cursor in original position when switching buffers
        if !&diff
            autocmd BufLeave * let b:winview = winsaveview()
            autocmd BufEnter * if exists('b:winview') | call winrestview(b:winview) | endif
        endif

        " Make 'autoread' work more responsively
        autocmd BufEnter    * silent! checktime
        autocmd CursorHold  * silent! checktime
        autocmd CursorMoved * silent! checktime

        " Restart with cursor in the location from last session.
        autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
    augroup END

]])
