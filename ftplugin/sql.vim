" Documentation {{{1
" This script gives you the abliity to run SQLServer queries from within Vim.
" The following key mappings are provided:
"
" F5 - submit the whole file to SQLServer
" F5 (in visual mode) - submit the visual selection to SQLServer
" Shift+F5 - submit the paragraph to SQLServer
" Ctrl+F5 - select from a list of special queries to run
" <leader>F5 - select or create new sqlcmd connection string parameters
" F5 (in the query results buffer) - rerun the same query
"
" sqlcmd connection strings are stored as a Vim dictionary in the
" .sqlConnections file in this file's folder. It is .gitignored to keep that
" information private. The dictionary's values contain whatever parameters are
" needed to connect to the database, such as:
"       `-S server -d database -U userid -P password`
"
" Prerequisite
"   - sqlcmd command-line utility (comes with SSMS or maybe Visual Studio)
" Bonuses
"   - EasyAlign aligns the text into columns, but only if it's installed.
"         https://github.com/junegunn/vim-easy-align
"   - csv.vim, among MANY other things, highlights the columns.
"         https://github.com/chrisbra/csv.vim

" Mappings {{{1
nnoremap <buffer> <F5> :call <SID>SQLRun('file')<CR>
nnoremap <buffer> <S-F5> :call <SID>SQLRun('paragraph')<CR>
vnoremap <buffer> <F5> :<C-U>call <SID>SQLRun('selection')<CR>
nnoremap <buffer> <C-F5> :call <SID>SQLRunSpecial()<CR>
nnoremap <buffer> <leader><F5> :call <SID>GetConnectionInfo()<CR>
imap <buffer> <F5> <Esc><F5>
imap <buffer> <S-F5> <Esc><S-F5>
imap <buffer> <C-F5> <Esc><C-F5>

function! s:SQLRun(object) " {{{1
    if !exists('b:sqlConnectionName') && !s:GetConnectionInfo()
        return
    endif

    call s:WriteTempFile(a:object)
    call s:GotoResultsBuffer(expand('%:t:r'), b:sqlConnectionName, b:sqlTempFile)
    call s:RunQuery()
endfunction

function! s:SQLRunSpecial() " {{{1
    let [l:choice,_] = s:Choose('Select a special instruction to perform.',
        \ ['List all tables'
        \ ,'Describe table/view under cursor (sp_help)'
        \ ,'List all stored procedures'
        \ ,'List all views'
        \ ,'List all triggers'
        \ ,'T-SQL definition of object (procs, views, triggers, etc.)'
        \ ])
    if l:choice > 0
        call s:SQLRun(l:choice)
    endif
endfunction

function! s:GetConnectionInfo() " {{{1
    let [l:choice, b:sqlConnectionName] = s:Choose('Select a connection name. Esc to create a new one.', s:sqlConnections)
    if l:choice == 0
        let b:sqlConnectionName = input('Enter a name for the new connection: ')
        if b:sqlConnectionName == ''
            unlet b:sqlConnectionName
        else
            let s:sqlConnections[b:sqlConnectionName] = input('Enter the slqcmd parameters "' . b:sqlConnectionName . '" will use: ')
            call writefile([string(s:sqlConnections)], s:sqlConnectionsFile)
        endif
    endif
    return exists('b:sqlConnectionName')
endfunction

function! s:Choose(prompt, choices) " {{{1
    if empty(a:choices)
        return [0, '']
    endif
    let l:choices = type(a:choices) == v:t_dict ? sort(values(map(copy(a:choices), {k,v -> k . ' -▷ ' . v}))) : a:choices
    let l:choice = 1
    let l:cmdheight = &cmdheight
    let &cmdheight = len(l:choices)+1
    while 1
        mode
        echo a:prompt . '  [Keys: j/k/Enter/Esc]'
        for i in range(1,len(l:choices))
            echo (i == l:choice ? '▶ ' : '  ') . l:choices[i-1]
        endfor
        let l:key = nr2char(getchar())
        if l:key ==# 'j'
            let l:choice = min([l:choice+1, len(l:choices)])
        elseif l:key ==# 'k'
            let l:choice = max([l:choice-1, 1])
        elseif l:key ==# nr2char(27)
            let l:choice = 0
            break
        elseif l:key ==# nr2char(13)
            break
        endif
    endwhile
    let &cmdheight = l:cmdheight
    mode
    return [l:choice, l:choice == 0 ? '' : split(l:choices[l:choice-1], ' -▷ ')[0]]
endfunction

function! s:WriteTempFile(object) " {{{1
    let l:z = @z
    let l:iskeyword = &iskeyword
    set iskeyword+=46
    set iskeyword+=91
    set iskeyword+=93
    if a:object == 'file'
        call writefile(getline(1,line('$')), b:sqlTempFile)
    elseif a:object == 'paragraph'
        call writefile(getline(line("'{"),line("'}")), b:sqlTempFile)
    elseif a:object == 'selection'
        normal! gv"zy
        call writefile(split(@z,'\n'), b:sqlTempFile)
    elseif a:object == 1  " List tables
        call writefile(["SELECT table_schema + '.' + table_name"
                     \ ,'FROM information_schema.tables'], b:sqlTempFile)
    elseif a:object == 2  " Describe table/view
        normal! "zyiw
        call writefile(["sp_help '" . @z ."';"], b:sqlTempFile)
    elseif a:object == 3  " List stored procedures
        call writefile(['SELECT name FROM sys.procedures'], b:sqlTempFile)
    elseif a:object == 4  " List views
        call writefile(['SELECT name FROM sys.views'], b:sqlTempFile)
    elseif a:object == 5  " List triggers
        call writefile(['SELECT name FROM sys.triggers'], b:sqlTempFile)
    elseif a:object == 6  " View or Stored Procedure definition
        normal! "zyiw
        call writefile(["select c.text"
                     \ ,"from syscomments c"
                     \ ,"join sysobjects o on o.id = c.id"
                     \ ,"where o.name = '" . @z . "';"], b:sqlTempFile)
    else
        throw 'Invalid object type.'
    endif
    let @z = l:z
    let &iskeyword = l:iskeyword
endfunction

function! s:GotoResultsBuffer(sqlQueryBuffer, sqlConnectionName, sqlTempFile) " {{{1
    let l:bufferName = a:sqlQueryBuffer . ' @ ' . a:sqlConnectionName
    let l:bufNum = bufnr(l:bufferName, 1)
    let l:winnr = bufwinnr(l:bufferName)
    if l:winnr == -1
        execute 'silent split ' . l:bufferName
        silent setlocal buftype=nofile buflisted noswapfile nowrap ft=csv statusline=Query\ Results:\ %f
        nnoremap <buffer> <F5> <Cmd>call <SID>RunQuery()<CR>
    else
        execute l:winnr . 'wincmd w'
    endif
    let b:sqlConnectionName = a:sqlConnectionName
    let b:sqlTempFile = a:sqlTempFile
endfunction

function! s:RunQuery() " {{{1
    " We're in the Results buffer now.
    let l:start = reltime()
    silent normal! ggdG _
    echon 'Querying...  '
    redraw!
    silent execute 'r! sqlcmd ' . s:sqlConnections[b:sqlConnectionName] . ' -s"|" -W -i ' . b:sqlTempFile
    echon 'Fixing line breaks...  '
    redraw!
    call s:JoinLines()
    echon 'Aligning columns...  '
    redraw!
    call s:AlignColumns()

    if exists(':CSVInit')
        let b:delimiter = '|'
        CSVInit!
    endif

    echon 'Finished in ' .  split(reltimestr(reltime(l:start)))[0] . ' seconds.'
endfunction

function! s:JoinLines() " {{{1
    let l:start = 2
    while l:start < line('$')
        call cursor(l:start,1)
        let l:end = search('^\s*(\d\+ rows affected)', 'cW') - 2
        if l:end < l:start
            break
        endif
        let l:required = count(getline(l:start), '|')
        while l:start < l:end
            let l:rows = 0
            let l:count = count(getline(l:start), '|')
            while l:count < l:required
                let l:rows += 1
                let l:count += count(getline(l:start + l:rows), '|')
            endwhile
            if l:rows > 0
                execute l:start.','.(l:start + l:rows).'join!'
                let l:end -= l:rows
            else
                let l:start += 1
            endif
        endwhile
        let l:start = l:end + 3
    endwhile
    silent execute '%s/'.nr2char(13).'$//e'
endfunction

function! s:AlignColumns() " {{{1
    if exists(':EasyAlign')
        silent execute '%s/^$\n^\s*\((\d\+ rows affected)\)/\r\1\r/e'
        silent execute '%s/^\s\+$//e'
        normal! gg
        let l:start = search('^.\+$','W')
        while l:start > 0
            let l:end = line("'}") - 1
            if l:end - l:start - 1 <= get(g:, 'sqlAlignLimit', 100)
                silent execute l:start . ',' . l:end . 'call easy_align#align(0,0,"command","* |")'
            endif
            normal! }
            let l:start = search('^.\+$','W')
        endwhile
    endif
    silent execute '%s/^$\n^\s*\((\d\+ rows affected)\)\(\n^$\)\?/\1\r/e'
    silent 1delete _
endfunction

function! SqlConnection() " {{{1
    return exists('b:sqlConnectionName') ? b:sqlConnectionName : '<not selected>'
endfunction

" Start Here {{{1
setlocal statusline=Connection:\ %{SqlConnection()}\ \|\ %f

let s:sqlConnectionsFile = expand('<sfile>:p:h').'/.sqlConnections'
let s:sqlConnections = {}
if filereadable(s:sqlConnectionsFile)
    execute 'let s:sqlConnections = ' . readfile(s:sqlConnectionsFile)[0]
endif

let b:sqlTempFile = tempname()

" vim: foldmethod=marker
