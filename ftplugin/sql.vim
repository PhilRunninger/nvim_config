" Documentation {{{1
"                                                        File: ftplugin/sql.vim
"                                                      Author: Phil Runninger
" Introduction
"   This script gives you the ability to run SQL queries from within Vim.
"   Target platforms include SQL Server and Postgres, but since the platforms
"   are defined separately in the settings file, other platforms may work
"   without changes to this script.
"
" Settings File
"   All the information about the servers, databases, and the platforms
"   they're running on is stored in the .sqlSettings.json file in this
"   file's folder. It is .gitignored to keep that information private, but
"   here is an example to follow:
"
"   {
"     "options": {
"       "alignTimeLimit": 5.0
"     },
"     "platforms": {
"       "sqlserver": {"cmdline": "sqlcmd -S <svr> -d <db> -s\"|\" -W -I -i <file>"},
"       "postgresql": {"cmdline": "psql -U id -h <svr> -p <port> -d <db> -F\"|\" -f <file>", "options":{"doAlign":0}}
"     },
"     "specials": {
"       "list tables": {
"         "sqlserver":  "SELECT table_schema+'.'+table_name FROM information_schema.tables WHERE table_type = 'BASE TABLE'",
"         "postgresql": "SELECT table_schema||'.'||table_name FROM information_schema.tables WHERE table_type = 'BASE TABLE';"},
"       "describe table/view": {
"         "sqlserver":  "sp_help '<cWORD>'",
"         "postgresql": "\\d <cWORD>"}
"     },
"     "servers": {
"       "(local)": {"platform": "sqlserver", "databases": ["Northwinds", "Movies"]}
"       "PGSQL01": {"platform": "postgresql", "port": 5432, "databases": ["MyDB"]},
"     }
"   }
"
"   There are two options that govern how the script works. They can be placed
"   in the "options" object as a global option, or in the platform object to
"   be local to that platform.
"     - doAlign:        Set to 0 or 1 to turn column alignment off or on.
"     - alignTimeLimit: If the time estimate is below this number of seconds,
"         do the alignment.
"
"   The platform objects contain the commands used to run the SQL statements
"   for that platform. The command must print the query results to stdout. The
"   string may contain placeholders that are replaced when the query runs. The
"   placeholders <svr> and <db> are filled in with a key from the "servers"
"   object and a value from the "databases" list, as chosen by the user.
"   <file> is a temporary file that contains the SQL statements being run.
"   Other placeholders' values are stored in the corresponding server's
"   object. See <port> in the example above.
"
"   The "specials" object contains common queries. Using these prevents having
"   to write them over and over. These queries can make use of two other
"   placeholders: <cword> and <cWORD>. They are replaced by the word or WORD
"   under the cursor, respectively.
"
" Key Mappings
"   F5 - submit the whole file to the database
"   F5 (in visual mode) - submit the visual selection to the database
"   Shift+F5 - submit the paragraph to the database
"   Ctrl+F5 - select from a list of special queries to run
"   <leader>F5 - select from or edit the settings file
"   F5 (in the query results buffer) - rerun the same query
"
" Bonus Functionality
"   If the following plugins are installed, they will be used to improve the
"   look of the results.
"   - EasyAlign (https://github.com/junegunn/vim-easy-align) aligns the text
"       into columns, if output isn't too large.
"   - csv.vim (https://github.com/chrisbra/csv.vim) highlights the columns.

function! s:SQLRun(queryType, stayInResults) " {{{1
    try
        if !s:ConnectionIsSet() && !s:SetConnection()
            return
        endif
        call s:WriteTempFile(a:queryType)
        call s:GotoResultsBuffer(expand('%:t'), b:server, b:database, b:tempFile)
        call s:RunAndFormat()
        if !a:stayInResults
            wincmd p
        endif
    catch /.*/
        echo v:exception
    endtry
endfunction

function! s:ConnectionIsSet() " {{{1
    return get(b:, 'server', '') != '' && get(b:, 'database', '') != ''
endfunction

function! s:SetConnection() " {{{1
    try
        let connection = s:Choose('Connecting to:',
            \   sort(flatten(map(
            \       keys(s:Settings().servers), {_,v -> map(
            \           copy(s:Settings().servers[v].databases), {_,w -> v.' ▶ '.w})})))
            \  + ['Edit…'] )
        if connection == 'Edit…'
            execute 'tabedit '.s:sqlSettingsFile
            return 0
        endif
        let [b:server,b:database] = split(connection, ' ▶ ')

        if !empty(matchlist(getline(1), s:connectionStringPattern))
            silent normal! ggdd _
        endif
        silent call append(0, printf('-- Connection: %s.%s', b:server, b:database))
        redraw!
        return s:ConnectionIsSet()
    catch /.*/
        echo v:exception
    endtry
endfunction

function! s:WriteTempFile(queryType) " {{{1
    if a:queryType == 'file'
        let start = empty(matchlist(getline(1), s:connectionStringPattern)) ? 1 : 2
        call writefile(getline(start,line('$')), b:tempFile)

    elseif a:queryType == 'paragraph'
        call writefile(getline(line("'{"),line("'}")), b:tempFile)

    elseif a:queryType == 'selection'
        silent normal! gv"zy
        call writefile(split(@z,'\n'), b:tempFile)

    elseif a:queryType == 'special'
        let platform = s:ServerInfo().platform
        let special = s:Choose('Running special query:',
            \   sort(keys(filter(copy(s:Settings().specials), {k,v -> has_key(v,platform)}))))
        if special == ''
            throw 'Invalid selection. Aborting...'
        endif

        let cmdline = s:Settings().specials[special][platform]
        let cmdline = substitute(cmdline, '\C<cword>', expand('<cword>'), 'g')
        let cmdline = substitute(cmdline, '\C<cWORD>', expand('<cWORD>'), 'g')

        call writefile([cmdline], b:tempFile)

    endif
endfunction

function! s:GotoResultsBuffer(sqlQueryBuffer, server, database, tempFile) " {{{1
    let sequence = undotree().seq_cur
    let bufferName = fnamemodify(a:sqlQueryBuffer, ':r') . '.OUT(' . a:server . '.' . a:database . ')'
    let bufNum = bufnr(bufferName, 1)
    let winnr = bufwinnr(bufferName)
    if winnr == -1
        execute 'silent split ' . bufferName
        silent setlocal buftype=nofile buflisted noswapfile nowrap ft=csv
        nnoremap <buffer> <C-F5> :call <SID>SQLRun('special',1)<CR>
        nnoremap <buffer> <F5> :call <SID>RunAndFormat()<CR>
    else
        execute winnr . 'wincmd w'
    endif
    let b:server = a:server
    let b:database = a:database
    let b:tempFile = a:tempFile
    let b:sequence = sequence
endfunction

function! s:RunAndFormat() " {{{1
    " We're in the Results buffer now.
    let startTime = reltime()
    silent normal! ggdG _
    let querying = s:RunQuery()

    silent execute 'keeppatterns %s/^\s\+$//e'
    silent execute 'keeppatterns %s/^\s*\((\d\+ rows\?\( affected\)\?)\)/\r\1\r/e'

    let joining = s:JoinLines()
    let aligning = s:AlignColumns()

    silent execute 'keeppatterns g/^$\n^$/d'
    silent execute 'keeppatterns g/^$\n^\s*(\d\+ rows\?\( affected\)\?)/d'

    normal gg

    echomsg printf('Elapsed: %f seconds (Query: %f  Join: %f  Align: %f)', reltimefloat(reltime(startTime)), querying, joining, aligning)
endfunction

function! s:RunQuery() " {{{1
    let startTime = reltime()
    echon 'Querying...  '
    redraw!
    let cmdline = s:Platform().cmdline
    let cmdline = substitute(cmdline, '<svr>', escape(b:server, '\'), '')
    let cmdline = substitute(cmdline, '<db>', b:database, '')
    let cmdline = substitute(cmdline, '<file>', escape(b:tempFile, '\'), '')
    let parm = matchstr(cmdline, '<\w\{-}>')
    while parm != ''
        let cmdline = substitute(cmdline, parm, get(s:ServerInfo(), parm[1:-2], ''), '')
        let parm = matchstr(cmdline, '<\w\{-}>')
    endwhile
    silent execute '0r! '.cmdline
    silent execute 'keeppatterns %s/\($\n\)\+\%$//e'
    let elapsed = reltimefloat(reltime(startTime))
    let hours = float2nr(elapsed / 3600)
    let minutes = float2nr(fmod(elapsed,3600) / 60)
    let seconds = fmod(elapsed, 60)
    call append(line('$'), printf('%02d:%02d:%06.3f | Seq:%d -> %s', hours, minutes, seconds, b:sequence, b:tempFile))
    return elapsed
endfunction

function! s:JoinLines() " {{{1
    let startTime = reltime()
    echon 'Fixing line breaks...  '
    redraw!
    let startRow = 1
    while startRow < line('$')
        call cursor(startRow,1)
        let endRow = search('^\s*(\d\+ rows\?\( affected\)\?)', 'cW') - 1
        if endRow == -1
            break
        endif
        let required = count(getline(startRow), '|')
        let startRow += 2
        while startRow < endRow && required > 0
            let rows = 0
            let count = count(getline(startRow), '|')
            let countNext = count(getline(startRow+1), '|')
            while startRow + rows < endRow && (count < required || countNext == 0)
                let rows += 1
                let count += count(getline(startRow + rows), '|')
                let countNext = count(getline(startRow + rows + 1), '|')
            endwhile
            if rows > 0
                execute startRow.','.(startRow + rows).'join'
                let endRow -= rows
            else
                let startRow += 1
            endif
        endwhile
        let startRow = endRow + 3
    endwhile
    silent execute 'keeppatterns %s/'.nr2char(13).'$//e'
    return reltimefloat(reltime(startTime))
endfunction

function! s:AlignColumns() " {{{1
    let startTime = reltime()
    echon 'Aligning columns...  '
    redraw!

    if exists(':EasyAlign') && s:Options().doAlign
        normal! gg
        let startRow = search('^.\+$','cW')
        while startRow > 0
            let columns = count(getline(startRow), '|') + 1
            let endRow = line("'}") - (line("'}") != line("$"))
            let rows = endRow - startRow - 1
            " These coefficients were derived from an experiment I did with
            " tables as long as 10000 rows (2 columns), as wide as 2048
            " columns (10 rows), and various sizes in between.
            let timeEstimate = 0.000299808*rows*columns + 0.014503037*columns
            if timeEstimate <= s:Options().alignTimeLimit
                echon printf('Aligning columns...  (rows: %d, columns: %d, estimate: %.1f seconds)', rows, columns, timeEstimate)
                redraw!
                silent execute startRow . ',' . endRow . 'EasyAlign * | {"lm":0, "rm":0}'
            endif
            normal! }
            let startRow = search('^.\+$','W')
        endwhile
    endif

    if exists(':CSVInit')
        let b:delimiter = '|'
        let b:csv_headerline = 0
        CSVInit!
    endif

    return reltimefloat(reltime(startTime))
endfunction

function! s:Settings() " {{{1
    return json_decode(readfile(s:sqlSettingsFile))
endfunction

function! s:ServerInfo() " {{{1
    return s:Settings().servers[b:server]
endfunction


function! s:Platform() " {{{1
    return s:Settings().platforms[s:ServerInfo().platform]
endfunction

function! s:Options() " {{{1
    return extend(
                \ get(s:Settings(),'options',{"alignTimeLimit": 5.0, "doAlign": 1}),
                \ get(s:Platform(),'options',{}),
                \ 'force')
endfunction

function! s:Choose(prompt, choices)   " {{{1
    let s:choices = a:choices
    let response = input(a:prompt.' ', '', 'customlist,SQLCompletion')
    return index(a:choices, response) == -1 ? '' : response
endfunction

function! SQLCompletion(A, L, P) " {{{1
    return filter(copy(s:choices), {_,v -> v =~ a:A})
endfunction

" Start Here {{{1
let s:sqlSettingsFile = expand('<sfile>:p:h').'/.sqlSettings.json'
let s:connectionStringPattern = '^-- Connection: \(.\+\)\.\([^.]\+\)$'

let b:tempFile = tempname()

let tagline = matchlist(getline(1), s:connectionStringPattern)
if !empty(tagline)
    let b:server = tagline[1]
    let b:database = tagline[2]
endif

nnoremap <silent> <buffer> <leader><F5> :call <SID>SetConnection()<CR>
" Run the SQL and put cursor in the results window.
nnoremap <silent> <buffer> g<F5> :call <SID>SQLRun('file',1)<CR>
nnoremap <silent> <buffer> g<S-F5> :call <SID>SQLRun('paragraph',1)<CR>
vnoremap <silent> <buffer> g<F5> :<C-U>call <SID>SQLRun('selection',1)<CR>
nnoremap <silent> <buffer> g<C-F5> :call <SID>SQLRun('special',1)<CR>
" Run the SQL and keep the cursor in the SQL buffer window.
nnoremap <silent> <buffer> <F5> :call <SID>SQLRun('file',0)<CR>
nnoremap <silent> <buffer> <S-F5> :call <SID>SQLRun('paragraph',0)<CR>
vnoremap <silent> <buffer> <F5> :<C-U>call <SID>SQLRun('selection',0)<CR>
nnoremap <silent> <buffer> <C-F5> :call <SID>SQLRun('special',0)<CR>

"  vim: foldmethod=marker
