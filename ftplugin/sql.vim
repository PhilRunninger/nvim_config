" Documentation {{{1
"                                                        File: ftplugin/sql.vim
"                                                      Author: Phil Runninger
"
" This script gives you the abliity to run SQLServer queries from within Vim.
" The following key mappings are provided:
"
" F5 - submit the whole file to SQLServer
" F5 (in visual mode) - submit the visual selection to SQLServer
" Shift+F5 - submit the paragraph to SQLServer
" Ctrl+F5 - select from a list of special queries to run
" <leader>F5 - select from, add to, or edit the list of databases
" F5 (in the query results buffer) - rerun the same query
"
" Databases are stored as a list in the .sqlConnections.json file in this
" file's folder. It is .gitignored to keep that information private. The login
" to the database is assumed to use Windows authentication.
"
" Prerequisite
"   - sqlcmd command-line utility (comes with SSMS or maybe Visual Studio)
" Bonuses (used only if installed)
"   - EasyAlign aligns the text into columns, if output isn't too large.
"         https://github.com/junegunn/vim-easy-align
"   - csv.vim, among MANY other things, highlights the columns.
"         https://github.com/chrisbra/csv.vim

function! s:SQLRun(queryType) " {{{1
    if !s:ConnectionIsSet()
        let db = input(':SetConnection ',"\<C-Z>",'customlist,'.expand('<SID>').'FilterConnections')
        call s:SetConnection(db)
    endif

    call s:WriteTempFile(a:queryType)
    call s:GotoResultsBuffer(expand('%:t'), b:sqlInstance, b:sqlDatabase, b:sqlTempFile)
    call s:RunQuery()
endfunction

function! s:FilterSpecials(ArgLead, CmdLine, CursorPos) " {{{1
    return map(filter(copy(s:specialCommands), {_,v -> v.desc =~ a:ArgLead}), {_,w -> w.desc})
endfunction

function! s:SQLRunSpecial(arg) " {{{1
    let pick = filter(copy(s:specialCommands), {_,v -> v.desc == a:arg})[0].id
    call s:SQLRun(pick)
endfunction

function! s:FilterConnections(ArgLead, CmdLine, CursorPos) " {{{1
    let s:sqlConnections = []
    if filereadable(s:sqlConnectionsFile)
        let s:sqlConnections = sort(eval(join(readfile(s:sqlConnectionsFile),'')))
    endif
    return filter(copy(s:sqlConnections) + ['Edit…'], {_,v -> v =~ a:ArgLead})
endfunction

function! s:SetConnection(arg) " {{{1
    let b:sqlInstance = ''
    let b:sqlDatabase = ''

    if a:arg =~? 'edit…\?'
        execute 'vsplit '.s:sqlConnectionsFile
    else
        let connection = matchlist(a:arg, '^'.s:connectionStringPattern)
        if empty(connection)
            echomsg 'Bad syntax.'
        else
            if count(s:sqlConnections, a:arg) == 0
                call add(s:sqlConnections, a:arg)
                call writefile(split(json_encode(s:sqlConnections),',\zs'), s:sqlConnectionsFile)
            endif
            let b:sqlInstance = connection[1]
            let b:sqlDatabase = connection[3]
        endif

        let tagline = matchlist(getline(1), '-- Connection: '.s:connectionStringPattern)
        if !empty(tagline)
            silent normal! ggdd
        endif
        if s:ConnectionIsSet()
            call append(0, printf("-- Connection: %s.%s", b:sqlInstance, b:sqlDatabase))
        endif
    endif
endfunction

function! s:WriteTempFile(queryType) " {{{1
    let z = @z
    let iskeyword = &iskeyword
    set iskeyword+=46
    set iskeyword+=91
    set iskeyword+=93
    if a:queryType == 'file'
        let start = empty(matchlist(getline(1), '-- Connection: '.s:connectionStringPattern)) ? 1 : 2
        call writefile(getline(start,line('$')), b:sqlTempFile)

    elseif a:queryType == 'paragraph'
        call writefile(getline(line("'{"),line("'}")), b:sqlTempFile)

    elseif a:queryType == 'selection'
        silent normal! gv"zy
        call writefile(split(@z,'\n'), b:sqlTempFile)

    elseif a:queryType == 'listTables'
        call writefile(["SELECT table_schema + '.' + table_name FROM information_schema.tables ORDER BY 1"], b:sqlTempFile)

    elseif a:queryType == 'descTable'
        silent normal! "zyiw
        call writefile([printf("sp_help '%s'", @z)], b:sqlTempFile)

    elseif a:queryType == 'listViews'
        call writefile(['SELECT name FROM sys.views ORDER BY 1'], b:sqlTempFile)

    elseif a:queryType == 'top100'
        silent normal! "zyiw
        call writefile([printf('SELECT TOP 100 * FROM %s', @z)], b:sqlTempFile)

    elseif a:queryType == 'listProcs'
        call writefile(['SELECT name FROM sys.procedures'], b:sqlTempFile)

    elseif a:queryType == 'listTriggers'
        call writefile(['SELECT name FROM sys.triggers'], b:sqlTempFile)

    elseif a:queryType == 'objectT-SQL'
        silent normal! "zyiw
        let object = substitute(split(@z,'\.')[-1],'[\[\]]','','g')
        call writefile([printf("SELECT c.text FROM syscomments c JOIN sysobjects o ON o.id = c.id WHERE o.name = '%s'", object)], b:sqlTempFile)

    else
        throw 'Invalid query type.'

    endif
    let @z = z
    let &iskeyword = iskeyword
endfunction

function! s:GotoResultsBuffer(sqlQueryBuffer, sqlInstance, sqlDatabase, sqlTempFile) " {{{1
    let bufferName = fnamemodify(a:sqlQueryBuffer, ':r') . '.OUT.' . a:sqlInstance . '.' . a:sqlDatabase
    let bufNum = bufnr(bufferName, 1)
    let winnr = bufwinnr(bufferName)
    if winnr == -1
        execute 'silent buffer ' . bufferName
        silent setlocal buftype=nofile buflisted noswapfile nowrap ft=csv
        command! -buffer -nargs=1 -complete=customlist,<SID>FilterSpecials RunSpecialCommand :call <SID>SQLRunSpecial('<args>')
        nnoremap <buffer> <C-F5> :RunSpecialCommand<space><C-Z>
        nnoremap <buffer> <F5> :call <SID>RunQuery()<CR>
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
    echomsg printf('Elapsed: %f seconds (Query: %f  Join: %f  Align: %f)', reltimefloat(reltime(startTime)), querying, joining, aligning)
endfunction

function! s:SQLServer() " {{{1
    let startTime = reltime()
    echon 'Querying...  '
    redraw!
    silent execute 'r! sqlcmd -S' . b:sqlInstance . ' -d' . b:sqlDatabase.' -s"|" -W -I -i ' . b:sqlTempFile
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
setlocal wildcharm=<C-Z>

let s:sqlConnectionsFile = expand('<sfile>:p:h').'/.sqlConnections.json'

let s:specialCommands = [
            \  {'id':'listTables',   'desc':'List all tables'}
            \ ,{'id':'descTable',    'desc':'Describe table/view under cursor (sp_help)'}
            \ ,{'id':'listViews',    'desc':'List all views'}
            \ ,{'id':'top100',       'desc':'SELECT TOP 100 * FROM...'}
            \ ,{'id':'listProcs',    'desc':'List all stored procedures'}
            \ ,{'id':'listTriggers', 'desc':'List all triggers'}
            \ ,{'id':'objectT-SQL',  'desc':'T-SQL definition of object (procs, views, triggers, etc.)'}
            \ ]

let b:sqlTempFile = tempname()

let s:connectionStringPattern = '\([^.\\]\+\(\\[^.\\]\+\)\?\)\.\([^.\\]\+\)$'
let tagline = matchlist(getline(1), '-- Connection: '.s:connectionStringPattern)
if !empty(tagline)
    let b:sqlInstance = tagline[1]
    let b:sqlDatabase = tagline[3]
endif

command! -buffer -nargs=1 -complete=customlist,<SID>FilterConnections SetConnection :call <SID>SetConnection('<args>')
command! -buffer -nargs=1 -complete=customlist,<SID>FilterSpecials RunSpecialCommand :call <SID>SQLRunSpecial('<args>')
nnoremap <silent> <buffer> <F5> :call <SID>SQLRun('file')<CR>
nnoremap <silent> <buffer> <S-F5> :call <SID>SQLRun('paragraph')<CR>
vnoremap <silent> <buffer> <F5> :<C-U>call <SID>SQLRun('selection')<CR>
nnoremap <buffer> <C-F5> :RunSpecialCommand<space><C-Z>
nnoremap <buffer> <leader><F5> :SetConnection<space>

" vim: foldmethod=marker
