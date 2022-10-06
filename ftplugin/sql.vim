" Documentation {{{1
" This script gives you the abliity to run SQLServer queries from within Vim.
" The following key mappings are provided:
"
" F5 - submit the whole file to SQLServer
" F5 (in visual mode) - submit the visual selection to SQLServer
" Shift+F5 - submit the paragraph to SQLServer
" Ctrl+F5 - select from a list of special queries to run
" <leader>F5 - select from, or add to, list of servers and databases
" F5 (in the query results buffer) - rerun the same query
"
" Servers and databases are stored as a list in the .sqlConnections.json file
" in this file's folder. It is .gitignored to keep that information private.
" The login to the database is assumed to use Windows authentication.
"
" Prerequisite
"   - sqlcmd command-line utility (comes with SSMS or maybe Visual Studio)
" Bonuses
"   - EasyAlign aligns the text into columns, but only if it's installed.
"         https://github.com/junegunn/vim-easy-align
"   - csv.vim, among MANY other things, highlights the columns.
"         https://github.com/chrisbra/csv.vim

" Commands and Mappings {{{1
command! -buffer -nargs=1 -complete=customlist,<SID>FilterConnections SetConnection :call <SID>SetConnection('<args>')
command! -buffer -nargs=1 -complete=customlist,<SID>FilterSpecials RunSpecialCommand :call <SID>SQLRunSpecial('<args>')
nnoremap <silent> <buffer> <F5> :call <SID>SQLRun('file')<CR>
nnoremap <silent> <buffer> <S-F5> :call <SID>SQLRun('paragraph')<CR>
vnoremap <silent> <buffer> <F5> :<C-U>call <SID>SQLRun('selection')<CR>
nnoremap <buffer> <C-F5> :RunSpecialCommand<space>
nnoremap <buffer> <leader><F5> :SetConnection<space>

function! s:SQLRun(object) " {{{1
    if !s:ConnectionIsSet()
        echo 'Connect to a database first.'
        return
    endif

    call s:WriteTempFile(a:object)
    call s:GotoResultsBuffer(expand('%:t'), b:sqlInstance, b:sqlDatabase, b:sqlTempFile)
    call s:RunQuery()
    wincmd p
endfunction

function! s:FilterSpecials(ArgLead, CmdLine, CursorPos) " {{{1
    return map(filter(copy(s:specialCommands), {_,v -> v.desc =~ a:ArgLead}), {_,w -> w.desc})
endfunction

function! s:SQLRunSpecial(arg) " {{{1
    let pick = filter(copy(s:specialCommands), {_,v -> v.desc == a:arg})[0].id
    call s:SQLRun(pick)
endfunction

function! s:FilterConnections(ArgLead, CmdLine, CursorPos) " {{{1
    return filter(copy(s:sqlConnections), {_,v -> v =~ a:ArgLead})
endfunction

function! s:SetConnection(arg) " {{{1
    let b:sqlInstance = split(a:arg, '\.')[0]
    let b:sqlDatabase = split(a:arg, '\.')[1]
endfunction

function! s:WriteTempFile(object) " {{{1
    let z = @z
    let iskeyword = &iskeyword
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

    elseif a:object == 'listTables'
        call writefile(["SELECT table_schema + '.' + table_name"
                     \ ,'FROM information_schema.tables'], b:sqlTempFile)

    elseif a:object == 'descTable'
        normal! "zyiw
        call writefile(["sp_help '" . @z ."';"], b:sqlTempFile)

    elseif a:object == 'listViews'
        call writefile(['SELECT name FROM sys.views'], b:sqlTempFile)

    elseif a:object == 'preview'
        normal! "zyiw
        call writefile(['SELECT TOP 100 * FROM ' . @z .';'], b:sqlTempFile)

    elseif a:object == 'listProcs'
        call writefile(['SELECT name FROM sys.procedures'], b:sqlTempFile)

    elseif a:object == 'listTriggers'
        call writefile(['SELECT name FROM sys.triggers'], b:sqlTempFile)

    elseif a:object == 'objectT-SQL'
        normal! "zyiw
        call writefile(["select c.text"
                     \ ,"from syscomments c"
                     \ ,"join sysobjects o on o.id = c.id"
                     \ ,"where o.name = '" . substitute(split(@z,'\.')[-1],'[\[\]]','','g') . "';"], b:sqlTempFile)

    else
        throw 'Invalid object type.'

    endif
    let @z = z
    let &iskeyword = iskeyword
endfunction

function! s:GotoResultsBuffer(sqlQueryBuffer, sqlInstance, sqlDatabase, sqlTempFile) " {{{1
    let bufferName = fnamemodify(a:sqlQueryBuffer, ':r') . '.OUT.' . a:sqlInstance . '.' . a:sqlDatabase
    let bufNum = bufnr(bufferName, 1)
    let winnr = bufwinnr(bufferName)
    if winnr == -1
        execute 'silent split ' . bufferName
        silent setlocal buftype=nofile buflisted noswapfile nowrap ft=csv
        nnoremap <buffer> <F5> <Cmd>call <SID>RunQuery()<CR>
        nnoremap <buffer> <C-F5> <Cmd>call <SID>SQLRunSpecial()<CR>
    else
        execute winnr . 'wincmd w'
    endif
    let b:sqlInstance = a:sqlInstance
    let b:sqlDatabase = a:sqlDatabase
    let b:sqlTempFile = a:sqlTempFile
endfunction

function! s:RunQuery() " {{{1
    " We're in the Results buffer now.
    let startTime = reltime()
    silent normal! ggdG _
    let querying = s:SQLServer()
    let joining = s:JoinLines()
    let aligning = s:AlignColumns()
    echon printf('Elapsed: %f seconds (Query: %f  Join: %f  Align: %f)', reltimefloat(reltime(startTime)), querying, joining, aligning)
endfunction

function! s:SQLServer() " {{{1
    let startTime = reltime()
    echon 'Querying...  '
    redraw!
    silent execute 'r! sqlcmd -S' . b:sqlInstance . ' -d' . b:sqlDatabase.' -s"|" -W -i ' . b:sqlTempFile
    return reltimefloat(reltime(startTime))
endfunction

function! s:JoinLines() " {{{1
    let startTime = reltime()
    echon 'Fixing line breaks...  '
    redraw!
    let startRow = 2
    while startRow < line('$')
        call cursor(startRow,1)
        let endRow = search('^\s*(\d\+ rows affected)', 'cW') - 2
        if endRow == -2
            break
        endif
        let required = count(getline(startRow), '|')
        while startRow < endRow
            let rows = 0
            let count = count(getline(startRow), '|')
            while count < required
                let rows += 1
                let count += count(getline(startRow + rows), '|')
            endwhile
            if rows > 0
                execute startRow.','.(startRow + rows).'join!'
                let endRow -= rows
            else
                let startRow += 1
            endif
        endwhile
        let startRow = endRow + 3
    endwhile
    silent execute '%s/'.nr2char(13).'$//e'
    return reltimefloat(reltime(startTime))
endfunction

function! s:AlignColumns() " {{{1
    let startTime = reltime()
    echon 'Aligning columns...  '
    redraw!
    if exists(':EasyAlign')
        silent execute '%s/^$\n^\s*\((\d\+ rows affected)\)/\r\1\r/e'
        silent execute '%s/^\s\+$//e'
        normal! gg
        let startRow = search('^.\+$','W')
        while startRow > 0
            let columns = count(getline(startRow), '|') + 1
            let endRow = line("'}") - (line("'}") != line("$"))
            let rows = endRow - startRow - 1
            " These coefficients were derived from an experiment I did with
            " tables as long as 10000 rows (2 columns), as wide as 2048
            " columns (10 rows), and various sizes in between.
            let timeEstimate = 0.000299808*rows*columns + 0.014503037*columns
            if timeEstimate <= get(g:, 'sqlAlignTimeLimit', 5.0)
                echon printf('Aligning columns...  (rows: %d, columns: %d, estimate: %.1f seconds)', rows, columns, timeEstimate)
                redraw!
                silent execute startRow . ',' . endRow . 'call easy_align#align(0,0,"command","* |")'
            endif
            normal! }
            let startRow = search('^.\+$','W')
        endwhile
    endif

    if exists(':CSVInit')
        let b:delimiter = '|'
        CSVInit!
    endif
    silent execute '%s/^$\n^\s*(\(\d\+ rows affected\))\(\n^$\)\?/|\1|' . repeat('-._.',60) . '\r/e'
    silent 1delete _

    return reltimefloat(reltime(startTime))
endfunction

function! s:ConnectionIsSet() " {{{1
    return get(b:, 'sqlInstance', '') != '' && get(b:, 'sqlDatabase', '') != ''
endfunction

function! SqlConnection() " {{{1
    return s:ConnectionIsSet() ? b:sqlInstance . '.' . b:sqlDatabase : '<disconnected>'
endfunction

" Start Here {{{1
if &statusline !~? '@ %{SqlConnection()}'
    execute 'setlocal statusline='.escape(substitute(&statusline, '%f', '%f @ %{SqlConnection()}', ''),' ')
endif

let s:sqlConnectionsFile = expand('<sfile>:p:h').'/.sqlConnections.json'
let s:sqlConnections = []
if filereadable(s:sqlConnectionsFile)
    let s:sqlConnections = sort(eval(join(readfile(s:sqlConnectionsFile),'')))
endif

let s:specialCommands = [
            \  {'id':'listTables',   'desc':'List all tables'}
            \ ,{'id':'descTable',    'desc':'Describe table/view under cursor (sp_help)'}
            \ ,{'id':'listViews',    'desc':'List all views'}
            \ ,{'id':'preview',      'desc':'SELECT TOP 100 * FROM...'}
            \ ,{'id':'listProcs',    'desc':'List all stored procedures'}
            \ ,{'id':'listTriggers', 'desc':'List all triggers'}
            \ ,{'id':'objectT-SQL',  'desc':'T-SQL definition of object (procs, views, triggers, etc.)'}
            \ ]

let b:sqlTempFile = tempname()

" vim: foldmethod=marker
