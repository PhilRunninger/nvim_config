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
" Servers and databases are stored as a nested list in the
" .sqlConnections.json file in this file's folder. It is .gitignored to keep
" that information private. The login to the database is assumed to use
" Windows authentication.
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

function! s:SQLRun(object) " {{{1
    if !s:ConnectionIsSet() && !s:GetConnectionInfo()
        return
    endif

    call s:WriteTempFile(a:object)
    call s:GotoResultsBuffer(expand('%:t'), b:sqlInstance, b:sqlDatabase, b:sqlTempFile)
    call s:RunQuery()
    wincmd p
endfunction

function! s:SQLRunSpecial() " {{{1
    let [pick,_] = s:Choose('Select a special instruction to perform.', 0, 0,
        \ ['List all tables'
        \ ,'Describe table/view under cursor (sp_help)'
        \ ,'List all views'
        \ ,'SELECT TOP 100 FROM...'
        \ ,'List all stored procedures'
        \ ,'List all triggers'
        \ ,'T-SQL definition of object (procs, views, triggers, etc.)'
        \ ])
    if pick > -1
        call s:SQLRun(string(pick))
    endif
endfunction

function! s:GetConnectionInfo() " {{{1
    let [pickInstance,pickDatabase] = s:Choose('Pick or add a server and database. Esc to cancel.', 1, 1, s:sqlConnections)
    if pickInstance == -2
        return 0
    endif
    let b:sqlInstance = pickInstance == -1 ? input('Enter the name of the new server or server\instance: ') : s:sqlConnections[pickInstance][0]
    let b:sqlDatabase = (pickDatabase == -1 && b:sqlInstance != '') ? input('Enter the name of the new database: ') : s:sqlConnections[pickInstance][1][pickDatabase]
    if s:ConnectionIsSet()
        if pickInstance == -1
            call add(s:sqlConnections, [b:sqlInstance, [b:sqlDatabase] ])
            call writefile([json_encode(s:sqlConnections)], s:sqlConnectionsFile)
        elseif pickDatabase == -1
            call add(s:sqlConnections[pickInstance][1], b:sqlDatabase)
            call writefile([json_encode(s:sqlConnections)], s:sqlConnectionsFile)
        endif
        return 1
    endif
    return 0
endfunction

function! s:Choose(prompt, allowNew, twoDPick, choices) " {{{1
    " a:choices must be either:
    "   1) a list of strings - ['milk','bread','eggs']
    "   2) a list of lists, each containing a row value and a list of related
    "      column values - [ ['pets',['Spot','Fido']], ['cars',['Mustang']] ]
    " A dictionary would make this structure easier to understand, but they
    " are not sortable.
    let rowCount = len(a:choices)
    let width = a:twoDPick ? max(map(copy(a:choices), {_,v -> strchars(v[0])})) : 0
    let pick = [0, 0]
    let cmdheight = &cmdheight
    let &cmdheight = rowCount + 1 + a:allowNew
    while 1
        mode
        echo a:prompt . '    [Keys: ' . (a:twoDPick ? 'h/j/k/l' : 'j/k') . '/Enter/Esc]'

        for i in range(len(a:choices))
            if a:twoDPick
                let text = printf('  %'.width.'s%s', a:choices[i][0], i==pick[0] ? '🟥' : '  ')
                for j in range(len(a:choices[i][1]))
                    let text = printf('%s%s%s ', text, (i==pick[0] && j==pick[1]) ? '🟠' : '  ', a:choices[i][1][j])
                endfor
                if a:allowNew && i==pick[0]
                    let text = printf('%s%sNew...', text, pick[1]==len(a:choices[i][1]) ?  '🟠' : '  ')
                endif
                echo text
            else
                echo printf(' %s%s', i==pick[0] ? '🟥' : '  ', a:choices[i])
            endif
        endfor
        if a:allowNew
            if a:twoDPick
                echo printf('  %'.width.'s%s', 'New...', rowCount == pick[0] ? '🟥' : '  ')
            else
                echo printf(' %s%s', rowCount==pick[0] ? '🟥' : '  ', 'New...')
            endif
        endif

        let colCount = (pick[0] == rowCount || !a:twoDPick) ? 0 : len(a:choices[pick[0]][1])
        let key = nr2char(getchar())
        if key ==# 'j'
            let pick = [(pick[0] + 1) % (rowCount + a:allowNew), 0]
        elseif key ==# 'k'
            let pick = [(pick[0] + rowCount - 1 + a:allowNew) % (rowCount + a:allowNew), 0]
        elseif key ==# 'l' && a:twoDPick
            let pick[1] = (pick[1] + 1) % (colCount + a:allowNew)
        elseif key ==# 'h' && a:twoDPick
            let pick[1] = (pick[1] + colCount - 1 + a:allowNew) % (colCount + a:allowNew)
        elseif key ==# nr2char(27)
            let pick = [-2,-2]  " -2 == no selection
            break
        elseif key ==# nr2char(13)
            let pick[0] = pick[0] == rowCount ? -1 : pick[0]  " -1 == New row
            let pick[1] = pick[1] == colCount ? -1 : pick[1]  " -1 == New column
            break
        endif
    endwhile
    let &cmdheight = cmdheight
    mode
    return pick
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
    elseif a:object == '0'  " List tables
        call writefile(["SELECT table_schema + '.' + table_name"
                     \ ,'FROM information_schema.tables'], b:sqlTempFile)
    elseif a:object == '1'  " Describe table/view
        normal! "zyiw
        call writefile(["sp_help '" . @z ."';"], b:sqlTempFile)
    elseif a:object == '2'  " List views
        call writefile(['SELECT name FROM sys.views'], b:sqlTempFile)
    elseif a:object == '3'  " SELECT TOP 100 FROM...
        normal! "zyiw
        call writefile(["SELECT TOP 100 * FROM " . @z .";"], b:sqlTempFile)
    elseif a:object == '4'  " List stored procedures
        call writefile(['SELECT name FROM sys.procedures'], b:sqlTempFile)
    elseif a:object == '5'  " List triggers
        call writefile(['SELECT name FROM sys.triggers'], b:sqlTempFile)
    elseif a:object == '6'  " View or Stored Procedure definition
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
    silent execute '%s/^$\n^\s*(\(\d\+ rows affected\))\(\n^$\)\?/|\1|' . repeat('-._.-\~',40) . '\r/e'
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
    let s:sqlConnections = eval(join(readfile(s:sqlConnectionsFile),''))
    if !empty(s:sqlConnections)
        let s:sqlConnections = map(sort(copy(s:sqlConnections)), {_,v -> [v[0], sort(v[1])]})
    endif
endif

let b:sqlTempFile = tempname()

" vim: foldmethod=marker
