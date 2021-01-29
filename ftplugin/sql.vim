" This script gives you the commands and functions necessary to run SQLServer
" queries (and even DML and DDL statements) from within Vim. The following
" key mappings are provided:
"
" F5 - submit the whole file to SQLServer
" Shift+F5 - submit the paragraph to SQLServer
" F5 - submit the visual selection to SQLServer
" Ctrl+F5 - use sp_help to describe the table under the cursor
" <leader>F5 - update server and database name.
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
    call s:RunQuery(a:object != 'table')
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
        normal! "zy
        call writefile(split(@z,'\n'), s:sqlTempFile)
    elseif a:object == 'table'
        set iskeyword+=46
        set iskeyword+=91
        set iskeyword+=93
        normal! "zyiw
        call writefile(["sp_help '" . @z ."';"], s:sqlTempFile)
    else
        execute "write! " . s:sqlTempFile
    endif
    let &iskeyword = l:iskeyword
    let @z = l:z
endfunction

function! s:RunQuery(align)
    let s:sqlResults = bufnr('SQL-Results', 1)
    execute 'silent buffer ' . s:sqlResults
    normal! ggdG _
    execute 'r! sqlcmd -S ' . g:sqlServer . ' -d ' . g:sqlDatabase . ' -s"|" -W -i ' . s:sqlTempFile
    1delete _

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
    set ft=csv
endfunction

let s:sqlTempFile = get(s:, 'sqlTempFile', tempname())

nnoremap <buffer> <F5> :call <SID>SQLRun('file')<CR>
nnoremap <buffer> <S-F5> :call <SID>SQLRun('paragraph')<CR>
vnoremap <buffer> <F5> :<C-U>call <SID>SQLRun('selection')<CR>
nnoremap <buffer> <C-F5> :call <SID>SQLRun('describe')<CR>
nnoremap <buffer> <leader><F5> :call <SID>SQLInit(getline(line('.')))<CR>

