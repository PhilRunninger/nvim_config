" This script gives you the commands and functions necessary to run SQLServer
" queries (and even DML and DDL statements) from within Vim. The following
" key mappings are provided:
"
" F5 - submit the whole file to SQLServer
" Shift+F5 - submit the paragraph to SQLServer
" F5 - submit the visual selection to SQLServer
" Ctrl+F5 - use sp_help to describe the table under the cursor
" <leader>F5 - update server and database name.
" F5 (in the SQl-Results buffer) - rerun the same query
"
" You can set g:sqlServer and g:sqlDatabase an another file of your vim setup
" (like ~/.vim/after/ftplugin/sql.vim) so you don't have to enter it for
" every session. In that file you can also specify g:sqlAlignLimit to control
" when to stop aligning query results into columns; that becomes a lengthy
" process with many rows.
"
" g:sqlServer and g:sqlDatabase can be set in the SQL file as well. Use a
" comment, formatted like one of these, move your cursor to the line, and
" press <leader>F5.
"       -- -S server-name -d database-name
"       -- sqlServer:server-name sqlDatabase:database-name
"
" Usernames and passwords are not necessary in my current environment, as we
" use Windows authentication. Adding them to the mix shouldn't be too hard
" though.
"
" Prerequisites
"   - sqlcmd command-line utility (comes with SSMS or maybe Visual Studio)
"   - EasyAlign is a handy plugin for aligning the text into columns. This is
"     nice, but not necessary.
"         https://github.com/junegunn/vim-easy-align
"   - csv.vim is another nice plugin that, among MANY other things, provides
"     nice highlighting for the columns of data. Again, nice, but not needed.
"         https://github.com/chrisbra/csv.vim

function! s:SQLRun(object)
    if !exists('g:sqlServer') || !exists('g:sqlDatabase')
        call s:GetConnectionInfo()
    endif

    call s:WriteTempFile(a:object)
    call s:RunQuery(a:object != 'word')
endfunction

function! s:SQLInit(connection)
    let l:server = matchstr(a:connection, '\s\(-S\|sqlServer:\)\s*\zs\S\+')
    let l:database = matchstr(a:connection, '\s\(-d\|sqlDatabase:\)\s*\zs\S\+')
    let g:sqlServer = empty(l:server) ? g:sqlServer : l:server
    let g:sqlDatabase = empty(l:database) ? g:sqlDatabase : l:database
    call s:GetConnectionInfo()
endfunction

function! s:GetConnectionInfo()
    let g:sqlServer = input('Server Name: ', get(g:, 'sqlServer', ''))
    let g:sqlDatabase = input('Database Name: ', get(g:, 'sqlDatabase', ''))
endfunction

function! s:WriteTempFile(object)
    let l:iskeyword = &iskeyword
    let l:z = @z
    if a:object == 'paragraph'
        execute "'{,'}write! " . s:sqlTempFile
    elseif a:object == 'selection'
        normal! gv"zy
        call writefile(split(@z,'\n'), s:sqlTempFile)
    elseif a:object == 'word'
        set iskeyword+=46
        set iskeyword+=91
        set iskeyword+=93
        normal! "zyiw
        call writefile(["sp_help '" . @z ."';"], s:sqlTempFile)
    else
        execute "1,$write! " . s:sqlTempFile
    endif
    let &iskeyword = l:iskeyword
    let @z = l:z
endfunction

function! s:RunQuery(align)
    let s:sqlResults = bufnr('SQL-Results', 1)
    execute 'silent buffer ' . s:sqlResults
    silent normal! ggdG _
    silent execute 'r! sqlcmd -S ' . g:sqlServer . ' -d ' . g:sqlDatabase . ' -s"|" -W -i ' . s:sqlTempFile
    silent 1delete _
    call s:JoinLines()
    call s:AlignColumns(a:align)
    silent setlocal buftype=nofile noswapfile nowrap ft=csv
endfunction

function! s:JoinLines()
    " If a column contains newlines, records are split into multiple rows, and
    " sqlcmd marks the end of records with a ^M character (ASCII 13), Test
    " line 1 to see if we can bypass joining the lines back together.
    if getline(1) !~ nr2char(13).'$'
        return
    endif

    " Join all lines that don't end with ^M to the next line.
    while search('[^'.nr2char(13).']$', 'cw')
        execute 'global/[^'.nr2char(13).']$/join'
    endwhile

    " Clean up the buffer by removing the ^M characters.
    silent execute '%s/'.nr2char(13).'$//'
endfunction

function! s:AlignColumns(align)
    if a:align && exists(':EasyAlign')
        let l:start = 1
        call cursor(l:start,1)
        let l:end = search('^\s*(\d\+ rows affected)', 'cW')
        while l:end > 0
            if l:end - l:start < get(g:, 'sqlAlignLimit', 50)
                silent execute l:start . ',' . (l:end-1) . 'call easy_align#align(0,0,"command","* |ar")'
            endif
            let l:start = l:end+1
            call cursor(l:start,1)
            let l:end = search('^\s*(\d\+ rows affected)', 'W')
        endwhile
    endif
    silent execute '%s/^$\n^\s*\((\d\+ rows affected)\)/\1\r/e'
endfunction

let s:sqlTempFile = get(s:, 'sqlTempFile', tempname())

nnoremap <buffer> <F5> :call <SID>SQLRun('file')<CR>
nnoremap <buffer> <S-F5> :call <SID>SQLRun('paragraph')<CR>
vnoremap <buffer> <F5> :<C-U>call <SID>SQLRun('selection')<CR>
nnoremap <buffer> <C-F5> :call <SID>SQLRun('word')<CR>
nnoremap <buffer> <leader><F5> :call <SID>SQLInit(getline(line('.')))<CR>

augroup SQLResultsMapping
    autocmd!
    autocmd BufEnter SQL-Results nnoremap <buffer> <F5> <Cmd>:call <SID>RunQuery(1)<CR>
augroup END
