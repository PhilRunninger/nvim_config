function! s:PurgeFiles(folder, regex)
    let l:folder = expand(a:folder)
    " Read file listing into new buffer, and delete empty line.
    enew
    if has('unix')
        call execute ('r! ls ' . l:folder, 'silent')
    else
        call execute ('r! dir /b ' . l:folder, 'silent')
    endif
    execute '1delete'

    " Duplicate text on each line (minus the .swp extension). We now have:
    " swapfile without extension | swapfile
    " undofile | undofile
    call execute(a:regex, 'silent')

    " Change % path delimiters on left side to /, deleting the line if the
    " original file still exists.
    while search('%.*|', 'w') > 0
        if has('unix')
            call execute("%s/%\\ze.*|/\\//e", 'silent')
        else
            call execute("%s/%%\\ze.*|/:\\\\/e", 'silent')
            call execute("%s/%\\ze.*|/\\\\/e", 'silent')
        endif
        let n = line('$')
        while n > 0
            let file = split(getline(n), '|')
            if filereadable(file[0])
                execute n.'delete'
            endif
            let n -= 1
        endwhile
    endwhile

    " If any files remain in the list, the original file is gone, so we can
    " delete these swap/undo files.
    if line('$') > 0 && getline(1) > ""
        call execute ("%s/^.*|//e", 'silent')

        let n = line('$')
        echomsg 'Deleting '.n.' file(s) in '.l:folder.'...'
        while n > 0
            echomsg '  '.getline(n)
            call delete(l:folder . getline(n))
            let n -= 1
        endwhile
    else
        echomsg 'Nothing to delete in '.l:folder.'.'
    endif
    execute 'bwipeout! ' . bufnr('%')
endfunction

function! Purge()
    call s:PurgeFiles(&directory, "%s/^\\(.*\\)\\(\\.sw[a-p]$\\)/\\1|\\1\\2/e")
    call s:PurgeFiles(&undodir, "%s/^\\(.*\\)/\\1|\\1/e")
endfunction
