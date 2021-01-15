" This script gives you the commands and functions necessary to run SQLServer
" queries (and even DML and DDL statements) from within Vim. The following
" commands and key mappings are provided:
"
" SQLRunFile - F5 - submit the whole file to SQLServer
" SQLRunParagraph - Shift+F5 - submit the paragraph to SQLServer
" SQLRunSelection - F5 - submit the visual selection to SQLServer
" SQLDescribe - Ctrl+F5 - use sp_help to describe the table under the cursor
" SQLReset - reset the server and database name
"
" You can set g:sqlServer and g:sqlDatabase an another file of your vim setup
" (like ~/.vim/after/ftplugin/sql.vim) so you don't have to enter it for
" every session. In that file you can also specify g:sqlAlignLimit to control
" when to stop aligning query results into columns; that becomes a lengthy
" process with many rows.
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

function s:SQLRun(object)
    if !exists('g:sqlServer') || !exists('g:sqlDatabase')
        call s:GetConnectionInfo()
    endif

    call s:WriteTempFile(a:object)
    call s:RunQuery(a:object != 'table')
endfunction

function s:GetConnectionInfo()
    let g:sqlServer = input('Server Name: ', get(g:, 'sqlServer', ''))
    let g:sqlDatabase = input('Database Name: ', get(g:, 'sqlDatabase', ''))
endfunction

function s:WriteTempFile(object)
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

function s:RunQuery(align)
    let s:sqlResults = bufnr('SQL-Results', 1)
    execute 'silent buffer ' . s:sqlResults
    normal! ggdG _
    execute 'r! sqlcmd -S ' . g:sqlServer . ' -d ' . g:sqlDatabase . ' -s"|" -W -i ' . s:sqlTempFile
    1delete _

    if a:align && exists('*easy_align#align')
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

command SQLRunFile :call <SID>SQLRun('file')
command SQLRunParagraph :call <SID>SQLRun('paragraph')
command SQLRunSelection :call <SID>SQLRun('selection')
command SQLDescribe :call <SID>SQLRun('table')
command SQLReset :call <SID>GetConnectionInfo()

nnoremap <F5> <Cmd>SQLRunFile<CR>
nnoremap <S-F5> <Cmd>SQLRunParagraph<CR>
vnoremap <F5> <Cmd>SQLRunSelection<CR>
nnoremap <C-F5> <Cmd>SQLDescribe<CR>
